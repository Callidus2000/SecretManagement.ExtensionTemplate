function Unregister-SecretVault {
    <#
    .SYNOPSIS
    Unregisters the vault and removes inMemory data for security.

    .DESCRIPTION
    Unregisters the vault and removes inMemory data for security.

    .PARAMETER VaultName
    The name of the secret vault.

    .PARAMETER AdditionalParameters
    Additional parameters which where configured while creating the vault.

    .EXAMPLE
    Unregister-SecretVault -VaultName $vaultName

    Removes the registration

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '')]
    param (
        [string] $VaultName,
        [hashtable] $AdditionalParameters
    )

    Remove-Variable -Name "Vault_${vaultName}_MasterPassword" -Scope Script -Force -ErrorAction SilentlyContinue
    #Force a reconnection
    Remove-Variable -Name "Vault_${vaultName}" -Scope Script -Force -ErrorAction SilentlyContinue
}
