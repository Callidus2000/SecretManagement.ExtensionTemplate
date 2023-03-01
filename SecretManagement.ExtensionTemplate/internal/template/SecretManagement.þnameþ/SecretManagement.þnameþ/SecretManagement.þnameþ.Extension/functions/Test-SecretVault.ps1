
function Test-SecretVault {
    <#
    .SYNOPSIS
    Tests if the vault is configured correctly and if it is unlocked.

    .DESCRIPTION
    Tests if the vault is configured correctly and if it is unlocked.

    .PARAMETER VaultName
    The name of the secret vault.

    .PARAMETER AdditionalParameters
    Additional parameters which where configured while creating the vault.

    .EXAMPLE
    Test-SecretVault -VaultName $vaultname

    Returns true if successfull

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [string] $VaultName,
        [hashtable] $AdditionalParameters
    )
    # Workaround CaseSensitive HashTable
    $AdditionalParameters = @{} + $AdditionalParameters
    if ($AdditionalParameters.Verbose) { $VerbosePreference = 'continue' }
    Write-PSFMessage  "Test-SecretVault from $VaultName, AdditionalParameters=$($AdditionalParameters|ConvertTo-Json -Compress)"

    Write-PSFMessage -Level Verbose "SecretManagement: Testing Vault ${VaultName}"
    $vault = Get-SecretVault $VaultName -ErrorAction Stop
    if ($vault.ModuleName -ne 'SecretManagement.þnameþ') {
        Write-PSFMessage -Level Error "$vaultName was found but is not a þnameþ Vault."
        Wait-PSFMessage
        return $false
    }
    # TODO Perform some testing voodoo ;-)
    return $true
}
