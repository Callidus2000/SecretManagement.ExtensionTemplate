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
    $AdditionalParameters = @{} + $AdditionalParameters
    if ($AdditionalParameters.Verbose) { $VerbosePreference = 'continue' }

    Write-PSFMessage "Get-SecretInfo, Filter=$Filter, $VaultName, AdditionalParameters=$($AdditionalParameters|ConvertTo-Json -Compress)"
    return Get-NetwrixContainer -Filter $Filter -VaultName $VaultName -AdditionalParameters $AdditionalParameters -ReturnType SecretInformation
}

