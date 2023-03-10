

[CmdletBinding()]
param(
    $VaultConfig = 'þnameþDemo',
    [switch]$NoWatcher
)
$vaultsParameter = @{
    þnameþDemo =
    @{
        vaultName = "þnameþDemo"
        server    = "localhost"
        UserName  = $env:USERNAME
        password  = ConvertTo-SecureString -AsPlainText -String "THIS_SHOULDBE_SWAPPED"  # Please use something else like 'Get-Credential' ;-)
    }
}
Write-Host "`$PSScriptRoot=$PSScriptRoot"
# $PSScriptRoot has to be provided as a parameter as it's not available in the scriptblock
Enter-RSSession -OnStartArgumentList @($vaultsParameter.$VaultConfig, $PSScriptRoot) -onstart {
    param($vaultParam,$PSSC)
    $vp = $vaultParam
    $vaultName = $vaultParam.vaultName
    $myNewSecret = ConvertTo-SecureString "$(Get-Date)" -AsPlainText
    [pscredential]$myNewCred = New-Object System.Management.Automation.PSCredential ('SomeUser', $myNewSecret)
    Write-PSFMessage -Level Host "Rember: You can access the following default variables:"
    Write-PSFMessage -Level Host (@{
            '$vp'          = "Currently used vault config parameters"
            '$vaultName'   = "The current configured vault"
            '$myNewSecret' = "A new SecureString containing the current time"
            '$myNewCred'   = "A new Credential using `$myNewSecret"
        } | Format-Table -Wrap | Out-String)
    $additionalParameter = $vaultParam | ConvertTo-PSFHashtable -Exclude vaultName, password
    Write-PSFMessage "Register Vault $vaultName with additional parameters $($additionalParameter|ConvertTo-Json -Compress  )"
    $modulePath = join-path (split-path $PSSC) "SecretManagement.þnameþ"
    $manifestPath = Join-Path $modulePath "SecretManagement.þnameþ.psd1"
    Write-PSFMessage "Using modulePath '$modulePath'"
    Import-Module -force $manifestPath -Verbose
    Register-SecretVault -Name $vaultName -ModuleName $manifestPath -VaultParameters $additionalParameter
    Unlock-SecretVault -Name $vaultName -Password $vaultParam.password -Verbose
    if ($NoWatcher) {
        Write-PSFMessage -Level Host "Use 'Restart-RSSession' to restart  the session."
    }
    else {
        Write-PSFMessage -Level Host "Any File Change within '$modulePath' will lead to a restart of the session."
        Write-PSFMessage -Level Host "To disable this use 'Start-þnameþRunspace.ps1 -NoWatcher'"
        Start-RSRestartFileWatcher -Path "$modulePath" -IncludeSubdirectories
    }
    @(
        "Example commands to test the new vault (for copy'n'paste)"
        #TODO Fill in live names of already stored secret names ;-)
        "# Get-Secret -Vault `$Vaultname -Name foo"
        "# Get-Secret -Vault `$Vaultname -Name MyFirstPassword -Verbose"
        "# Get-SecretInfo -Vault `$Vaultname -Name foo"
        "# Get-SecretInfo -Vault `$Vaultname -Name MyFirstPassword"
        "# Set-Secret -Verbose -Vault `$Vaultname -Secret `$myNewSecret -Name foo"
        "# Set-Secret -Verbose -Vault `$Vaultname -Secret `$myNewSecret -Name Hubba"
        "# Set-SecretInfo -Verbose -Vault `$Vaultname  -Name foo -Metadata @{Beschreibung='Notiz'}"
        '# Set-Secret -Verbose -Vault $Vaultname -Secret $myNewCred -Name "NewFoo"') | ForEach-Object { Write-PSFMessage -Level Host $_ }
} -onend {
    Write-PSFMessage -Level Host "Removing all vaults which use a module named like '*þnameþ*'"
    Get-SecretVault | Where-Object modulepath -like '*þnameþ*' | Unregister-SecretVault
}