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

    .EXAMPLE
    Get-Secret -Vault $Vaultname -Name foobar
    [Error] Multiple credentials found; Search with Get-SecretInfo and require the correct one by *.MetaData.id
    Get-SecretInfo -Vault $Vaultname -Name foobar
    Name                                          Type         VaultName
    ----                                          ----         ---------
    foobar [5dd937c4-b0a0-ed11-a876-005056bce948] PSCredential PWSafeInt
    foobar [ef2fe11d-b0a0-ed11-a876-005056bce948] PSCredential PWSafeInt
    Get-Secret -Vault $Vaultname -Name ef2fe11d-b0a0-ed11-a876-005056bce948

    Returns the stored secret for the second entry foobar.

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [string] $Name,
        [string] $VaultName,
        [hashtable] $AdditionalParameters
    )
    $AdditionalParameters = @{} + $AdditionalParameters
    if ($AdditionalParameters.Verbose) { $VerbosePreference = 'continue' }

    Write-PSFMessage "Get-Secret, Name=$Name, $VaultName, AdditionalParameters=$($AdditionalParameters|ConvertTo-Json -Compress)"
    $secret = Get-NetwrixContainer -Filter $Name -VaultName $VaultName -AdditionalParameters $AdditionalParameters -ReturnType Secret
    Write-PSFMessage "Found `$secret=$($secret.gettype())"
    # Write-PSFMessage "Found `$secret=$($secret|ConvertTo-Json -Compress -Depth 4)"
    if ($secret.Count -gt 1 -and $secret -isnot [hashtable]) {
        Write-PSFMessage -Level Error 'Multiple credentials found; Search with Get-SecretInfo and require the correct one by *.MetaData.id'
        Wait-PSFMessage
        throw 'Multiple credentials found; Search with Get-SecretInfo and require the correct one by *.MetaData.id'
    }
    return $secret | Select-Object -First 1
}

