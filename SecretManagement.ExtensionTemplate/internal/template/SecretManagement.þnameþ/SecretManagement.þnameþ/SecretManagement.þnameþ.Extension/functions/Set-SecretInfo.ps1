﻿function Set-SecretInfo {
    <#
    .SYNOPSIS
    Updates additional fields of a single entry.

    .DESCRIPTION
    Updates additional fields of a single entry.

    .PARAMETER Name
    Name of the entry

    .PARAMETER Metadata
    The HashTable with the fields to update.
    Possible Keys: 'Username', 'Password', 'Name', 'Memo'

    .PARAMETER VaultName
    The name of the secret vault.

    .PARAMETER AdditionalParameters
    Additional parameters which where configured while creating the vault.

    .EXAMPLE
    Set-SecretInfo  -Vault $Vaultname  -Name foo -Metadata @{memo='Notiz 2';username='foo';password=$myNewSecret}

    Updates the entry with new memo.

    .EXAMPLE
    Set-SecretInfo  -Vault $Vaultname  -Name foo -Metadata @{name='Bar'}

    Renames the entry 'foo' to 'Bar'

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessforStateChangingFunctions', '')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '')]
    param (
        [string] $Name,
        [hashtable] $Metadata,
        [string] $VaultName,
        [hashtable] $AdditionalParameters
    )
    # Workaround CaseSensitive HashTable
    $AdditionalParameters = @{} + $AdditionalParameters
    if ($AdditionalParameters.Verbose) { $VerbosePreference = 'continue' }
    # TODO Perform update voodoo ;-)
    #region Change this code against something useful/more secret
    Set-PSFConfig -Module 'SecretManagement.þnameþ' -Name "DummyImplmentation.SecretInfo.$Name" -Value $Metadata -Hidden
    #endregion Change this code against something useful/more secret

    Wait-PSFMessage
    return $true
}
