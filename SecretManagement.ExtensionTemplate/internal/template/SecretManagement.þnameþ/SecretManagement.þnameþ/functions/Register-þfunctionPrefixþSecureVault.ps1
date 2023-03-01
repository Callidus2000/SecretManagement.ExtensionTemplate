function Register-þfunctionPrefixþSecureVault {
    <#
    .SYNOPSIS
    Registers a new Secretvault of type þnameþ.

    .DESCRIPTION
    Registers a new Secretvault of type þnameþ.

    #TODO Add parameter description

    .NOTES
    General notes
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (

        [parameter(mandatory = $true, ParameterSetName = "cmdLine")]
        [string]$VaultName
        # TODO add your specific parameters
    )
    # In order to register a vault you need the module name. For dev purposes
    # this code (see configuration.ps1) enables the detection if the module is installed
    # or the PSD1 file is imported directly.
    $myModulePath = "$ModuleRoot\SecretManagement.þnameþ.psd1"
    $psdData = Import-PowerShellDataFile $myModulePath
    $registerParam = @{
        ModuleName      = Get-PSFConfigValue 'SecretManagement.þnameþ.InterActiveRegister.modulepath'
        Name            = $VaultName
        VaultParameters = $PSBoundParameters | ConvertTo-PSFHashtable -Inherit -Exclude @(
            # TODO Include all function parameter names which should be transferred to the Vault-Parameters
            # 'Server'
            # 'Port'
            # 'Database'
            # 'UserName'
        )
    }
    $registerParam.VaultParameters.version = $psdData.ModuleVersion
    if ($PSCmdlet.ShouldProcess($name)) {
        Write-PSFMessage "Registering Vault $vault with Param $($registerParam|ConvertTo-Json -Compress)"
        Register-SecretVault @registerParam
    }
    else {
        Write-PSFMessage -Level Host "WhatIf used, no vault registered."
        Write-PSFMessage -Level Host "You may register the chosen vault later with the following command:`r`n@registerParam=$($registerParam|ConvertTo-Metadata -AsHashtable)`r`nRegister-þfunctionPrefixþSecureVault @registerParam"
    }
}