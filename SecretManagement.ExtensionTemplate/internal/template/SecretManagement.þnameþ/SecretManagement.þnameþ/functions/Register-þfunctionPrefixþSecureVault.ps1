function Register-þfunctionPrefixþSecureVault {
    <#
    .SYNOPSIS
    Registers a new Secretvault.

    .DESCRIPTION
    Registers a new Secretvault.

    .PARAMETER VaultName
    The name of the vault.

    .PARAMETER Server
    The hostname of the server which provides the service.

    .PARAMETER Port
    On which port is the server listening? Defaults to 11016.

    .PARAMETER Database
    The name of the Database.

    .PARAMETER UserName
    The username which is used to connect to the server. Has to be specified on vault level as Unlock-SecretVault only accepts a password instead credentials.

    .PARAMETER defaultOUName
    Under which OU should new entries be created by default?
    If not set the first entry of all active OUs, sorted by Type (Group before User) and Name will be used

    .PARAMETER defaultFormName
    Which password form should new entries be created by default?
    If not set the first entry of all active forms, sorted by field counts and name lenth will be used.
    This should be the less complex form of all ;-)

    .PARAMETER FormMapping
    The manual configured form mapping.

    .PARAMETER InterActive
    If this switch is used the user can interactively choose (via Out-GridView) an existing config from the installed Windows Client.

    .PARAMETER Confirm
    Not respected

    .PARAMETER WhatIf
    If used, the vault will not be registered but the register command will be printed

    .EXAMPLE
    Register-NetwrixSecureVault -VaultName myVault -Server myserver -Database PWDB -UserName fred

    Registers the given vault.
    .EXAMPLE
    Register-NetwrixSecureVault -VaultName myVault -Interactive

    Shows all preconfigured connections and stores it with the name myVault.
    .EXAMPLE
    Register-NetwrixSecureVault -Interactive

    Shows all preconfigured connections and stores it with the name of the database connection.
    .EXAMPLE
    Register-NetwrixSecureVault -Interactive -WhatIf

    Shows all preconfigured connections and show the commands necessary to configure it manually.

    .NOTES
    General notes
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (

        [parameter(mandatory = $true, ParameterSetName = "cmdLine")]
        [parameter(mandatory = $true, ParameterSetName = "interactiveWithRename")]
        [string]$VaultName,
        [parameter(mandatory = $true, ParameterSetName = "cmdLine")]
        [string]$Server,
        [string]$Port = "11016",
        [parameter(mandatory = $true, ParameterSetName = "cmdLine")]
        [string]$Database,
        [parameter(mandatory = $true, ParameterSetName = "cmdLine")]
        [string]$UserName,
        [parameter(mandatory = $false, ParameterSetName = "cmdLine")]
        [string]$defaultOUName,
        [parameter(mandatory = $false, ParameterSetName = "cmdLine")]
        [string]$defaultFormName,
        [parameter(mandatory = $false, ParameterSetName = "cmdLine")]
        $FormMapping,
        [parameter(mandatory = $true, ParameterSetName = "interactive")]
        [parameter(mandatory = $true, ParameterSetName = "interactiveWithRename")]
        [switch]$InterActive
    )

    $myModulePath = "$ModuleRoot\SecretManagement.NetwrixPasswordSecure.psd1"
    $psdData = Import-PowerShellDataFile $myModulePath
    $registerParam = @{
        ModuleName = Get-PSFConfigValue 'SecretManagement.NetwrixPasswordSecure.InterActiveRegister.modulepath'
    }
    if ($PSCmdlet.ParameterSetName -eq 'interactive') {
        $registryLocations = Get-PSFConfigValue -FullName 'SecretManagement.NetwrixPasswordSecure.InterActiveRegister.registy'
        $possibleVaults = @()
        foreach ($regLoc in $registryLocations) {
            $regVaultNames = Get-ChildItem $regLoc -ErrorAction SilentlyContinue | Select-Object -ExpandProperty PSChildName

            foreach ($regVaultName in $regVaultNames) {
                $properties = Get-ItemProperty "$regLoc\$regVaultName"
                # $settingsHash.vaultName=$vaultName
                $possibleVaults += [PSCustomObject][ordered]@{
                    VaultName = $regVaultName
                    Server    = $properties.HostIP
                    DataBase  = $properties.DataBaseName
                }
            }
        }
        $fileConfig = Get-PSFConfigValue -FullName 'SecretManagement.NetwrixPasswordSecure.InterActiveRegister.file'
        if (Test-Path $fileConfig) {
            $localConfig = Get-Content $fileConfig | ConvertFrom-Json | Select-Object -ExpandProperty DatabaseProfiles
            foreach ($conf in $localConfig) {
                $possibleVaults += [PSCustomObject][ordered]@{
                    VaultName = $conf.ProfileName
                    Server    = $conf.HostIP
                    DataBase  = $conf.DataBaseName
                }

            }
        }
        $newVaultData = $possibleVaults | Sort-Object -Unique -Property VaultName | Out-GridView -OutputMode Single -Title "Choose which account should be added as a Secret Management Vault"
        if ($null -eq $newVaultData) {
            Write-PSFMessage -Level Warning "No data chosen, exit."
            return
        }
        Write-PSFMessage "Using chosen data: $($newVaultData|ConvertTo-Json -Compress)"
        if (-not [string]::IsNullOrWhiteSpace($VaultName)) { $newVaultData.vaultName=$VaultName}
        $userName = Get-NetwrixUserInput -Title "Enter username for the new vault $($newVaultData.vaultName)" -Default $env:USERNAME
        if ([string]::IsNullOrWhiteSpace($userName)) {
            Write-PSFMessage -Level Warning "No username entered, cannot configure vault."
            return
        }
        $registerParam.Name = $newVaultData.VaultName
        $additionalParameter = @{
            'Server'   = $newVaultData.Server
            'Port'     = $Port
            'Database' = $newVaultData.Database
            'UserName' = $UserName
        }
    }
    else {
        $registerParam.Name =$VaultName
        $additionalParameter = $PSBoundParameters | ConvertTo-PSFHashtable -Inherit -Include @(
            'Server'
            'Port'
            'Database'
            'UserName'
            'defaultOUName'
            'defaultFormName'
            'FormMapping'
        )
        $additionalParameter.Port = $Port
    }
    $registerParam.VaultParameters = $additionalParameter
    $additionalParameter.version = $psdData.ModuleVersion
    if ($PSCmdlet.ShouldProcess($name)) {
        Write-PSFMessage "Registering Vault $vault with Param $($registerParam|ConvertTo-Json -Compress)"
        # Write-PSFMessage "Registering Vault $vault with Param $($additionalParameter|ConvertTo-Json -Compress) and Module $myModulePath, Version $($psdData.ModuleVersion)"
        Register-SecretVault @registerParam
        # Register-SecretVault -Name $vaultName -ModuleName $myModulePath -VaultParameters $additionalParameter
    }
    else {
        Write-PSFMessage -Level Host "WhatIf used, no vault registered."
        Write-PSFMessage -Level Host "You may register the chosen vault later with the following command:`r`n@registerParam=$($registerParam|ConvertTo-Metadata -AsHashtable)`r`nRegister-SecretVault @registerParam"
    }
}