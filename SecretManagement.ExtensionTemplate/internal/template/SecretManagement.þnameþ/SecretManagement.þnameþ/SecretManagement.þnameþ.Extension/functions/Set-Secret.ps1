function Set-Secret {
    <#
    .SYNOPSIS
    Updates a secret stored in the vault.

    .DESCRIPTION
    Updates a secret stored in the vault.

    .PARAMETER Name
    Name of the entry

    .PARAMETER Secret
    The New Secret. Can be a SecureString or a PSCredential-object

    .PARAMETER VaultName
    The name of the secret vault.

    .PARAMETER AdditionalParameters
    Additional parameters which where configured while creating the vault.

    .EXAMPLE
    Set-Secret -Verbose -Vault $Vaultname -Secret (Get-Credential) -Name foo

    Updates username and password of the entry.

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessforStateChangingFunctions', '')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '')]
    param (
        [string] $Name,
        [object] $Secret,
        [string] $VaultName,
        [hashtable] $AdditionalParameters
    )
    # Workaround CaseSensitive HashTable
    $AdditionalParameters = @{} + $AdditionalParameters
    if ($AdditionalParameters.Verbose) { $VerbosePreference = 'continue' }
    # TODO Perform update voodoo ;-)
    Wait-PSFMessage
    return $true
}

