function Unlock-SecretVault {
    <#
    .SYNOPSIS
    Unlocks the vault.

    .DESCRIPTION
    Unlocks the vault.

    .PARAMETER Password
    The password needed for unlocking.

    .PARAMETER VaultName
    The name of the secret vault.

    .PARAMETER AdditionalParameters
    Additional parameters which where configured while creating the vault.

    .EXAMPLE
    Unlock-SecretVault -VaultName $vaultName -Password (Read-Host -AsSecureString)

    Unlocks the vault

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [SecureString] $Password,
        [string] $VaultName,
        [hashtable] $AdditionalParameters
    )

    $AdditionalParameters = @{} + $AdditionalParameters

    Write-PSFMessage "Unlocking SecretVault $VaultName, AdditionalParameters=$($AdditionalParameters|ConvertTo-Json -Compress)"
    $vault = Get-SecretVault $VaultName -ErrorAction Stop
    Write-PSFMessage "Vault= $($vault|ConvertTo-Json -Compress)"
    if(-not $AdditionalParameters){
        $AdditionalParameters=$vault.VaultParameters|ConvertTo-PSFHashtable
    }
    $vaultName = $vault.Name
    Write-PSFMessage "Hubba"
    if ($vault.ModuleName -ne 'SecretManagement.NetwrixPasswordSecure') {
        Write-PSFMessage -Level Error "$vaultName was found but is not a NetwrixPasswordSecure Vault."
        return $false
    }
    Set-Variable -Name "Vault_${vaultName}_MasterPassword" -Scope Script -Value $Password -Force
    #Force a reconnection
    Remove-Variable -Name "Vault_${vaultName}" -Scope Script -Force -ErrorAction SilentlyContinue
    if (-not (Test-SecretVault -VaultName $vaultName -AdditionalParameters $AdditionalParameters)) {
        Write-PSFMessage -Level Error "${vaultName}: Failed to unlock the vault"
        return $false
    }
    Write-PSFMessage "SecretVault $vault unlocked successfull"
    return $true
}