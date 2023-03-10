function Get-Secret {
    <#
    .SYNOPSIS
    Query a single secret.

    .DESCRIPTION
    Query a single secret.

    .PARAMETER Name
    Name to be searched for.

    .PARAMETER VaultName
    The name of the secret vault.

    .PARAMETER AdditionalParameters
    Additional parameters which where configured while creating the vault.

    .EXAMPLE
    Get-Secret -Vault $Vaultname -Name foo

    Returns the stored secret for the entry foo.

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [string] $Name,
        [string] $VaultName,
        [hashtable] $AdditionalParameters
    )
    # Workaround CaseSensitive HashTable
    $AdditionalParameters = @{} + $AdditionalParameters
    if ($AdditionalParameters.Verbose) { $VerbosePreference = 'continue' }

    Write-PSFMessage "Get-Secret, Name=$Name, $VaultName, AdditionalParameters=$($AdditionalParameters|ConvertTo-Json -Compress)"
    # TODO Perform Retrieval voodoo ;-)

    #region Change this code against something useful/more secret
    $secret=Get-PSFConfigValue -FullName "SecretManagement.þnameþ.DummyImplmentation.Secrets.$Name" -Fallback (ConvertTo-SecureString "Foo" -AsPlainText)
    #endregion Change this code against something useful/more secret

    # Example Code has to be removed!
    # $secret = Get-þfunctionPrefixþSecret
    # Write-PSFMessage "Found `$secret=$($secret.gettype())"
    # # Check if only one secret was retrieved
    # if ($secret.Count -gt 1 -and $secret -isnot [hashtable]) {
    #     Write-PSFMessage -Level Error 'Multiple credentials found; Search with Get-SecretInfo and require the correct one by *.MetaData.id'
    #     Wait-PSFMessage
    #     throw 'Multiple credentials found; Search with Get-SecretInfo and require the correct one by *.MetaData.id'
    # }
    return $secret | Select-Object -First 1
}

