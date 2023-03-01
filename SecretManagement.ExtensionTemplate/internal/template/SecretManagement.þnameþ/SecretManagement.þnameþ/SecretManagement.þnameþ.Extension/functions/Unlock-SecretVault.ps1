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
    # Workaround CaseSensitive HashTable
    $AdditionalParameters = @{} + $AdditionalParameters

    Write-PSFMessage "Unlocking SecretVault $VaultName, AdditionalParameters=$($AdditionalParameters|ConvertTo-Json -Compress)"
    $vault = Get-SecretVault $VaultName -ErrorAction Stop
    if ($vault.ModuleName -ne 'SecretManagement.þnameþ') {
        Write-PSFMessage -Level Error "$vaultName was found but is not a þnameþ Vault."
        Wait-PSFMessage
        return $false
    }
    # TODO Should the master password be cached?
    # Set-Variable -Name "Vault_${vaultName}_MasterPassword" -Scope Script -Value $Password -Force

    # TODO Perform the connection voodoo ;-)
    return $true
}