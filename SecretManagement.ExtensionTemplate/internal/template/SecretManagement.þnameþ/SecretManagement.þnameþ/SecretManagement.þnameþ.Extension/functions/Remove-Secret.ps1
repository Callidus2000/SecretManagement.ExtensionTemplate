
function Remove-Secret {
    <#
    .SYNOPSIS
    Removes a secret from the vault. NOT implemented yet.

    .DESCRIPTION
    Removes a secret from the vault. NOT implemented yet.

    .PARAMETER Name
    Name to be searched for.

    .PARAMETER VaultName
    The name of the secret vault.

    .PARAMETER AdditionalParameters
    Additional parameters which where configured while creating the vault.

    .EXAMPLE
    An example
    is not neccessary

    As not implemented

    .NOTES
    General notes
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessforStateChangingFunctions', '')]
    [CmdletBinding()]
    param (
        [string] $Name,
        [string] $VaultName,
        [hashtable] $AdditionalParameters
    )
    throw "Not Implemented"
}

