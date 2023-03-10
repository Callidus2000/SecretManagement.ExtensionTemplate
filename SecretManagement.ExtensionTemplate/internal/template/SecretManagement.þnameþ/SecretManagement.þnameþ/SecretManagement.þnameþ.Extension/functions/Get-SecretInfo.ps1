function Get-SecretInfo {
    <#
    .SYNOPSIS
    Returns SecretmanagementInformation objects for the requested entries.

    .DESCRIPTION
    Returns SecretmanagementInformation objects for the requested entries.

    .PARAMETER Filter
    The name to be searched

    .PARAMETER VaultName
    The name of the secret vault.

    .PARAMETER AdditionalParameters
    Additional parameters which where configured while creating the vault.

    .EXAMPLE
    Get-SecretInfo -Vault $Vaultname -Name foobar
    Name                                          Type         VaultName
    ----                                          ----         ---------
    foobar [5dd937c4-b0a0-ed11-a876-005056bce948] PSCredential PWSafeInt
    foobar [ef2fe11d-b0a0-ed11-a876-005056bce948] PSCredential PWSafeInt

    Returns the stored secret info.

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [string] $Filter,
        [string] $VaultName,
        [hashtable] $AdditionalParameters
    )
    # Workaround CaseSensitive HashTable
    $AdditionalParameters = @{} + $AdditionalParameters
    if ($AdditionalParameters.Verbose) { $VerbosePreference = 'continue' }

    Write-PSFMessage "Get-SecretInfo, Filter=$Filter, $VaultName, AdditionalParameters=$($AdditionalParameters|ConvertTo-Json -Compress)"
    # TODO Perform Retrieval voodoo ;-) or just throw 'NotImplemented' if your vault does not support it
    #region Change this code against something useful/more secret
    Write-PSFMessage "Query Config 'SecretManagement.þnameþ.DummyImplmentation.SecretInfo.$Filter'"
    $metaData = Get-PSFConfigValue -FullName "SecretManagement.þnameþ.DummyImplmentation.SecretInfo.$Filter" -Fallback (@{info = "This secret will evaporate with session closure" })
    Write-PSFMessage "Found info $($info|ConvertTo-Json -Compress)"
    Wait-PSFMessage
    $info = [Microsoft.PowerShell.SecretManagement.SecretInformation]::new(
        $filter, # Name of secret
        [Microsoft.PowerShell.SecretManagement.SecretType]::PSCredential, # Secret data type [Microsoft.PowerShell.SecretManagement.SecretType]
        $VaultName, # Name of vault
        $metaData)
    return $info
    #endregion Change this code against something useful/more secret
}

