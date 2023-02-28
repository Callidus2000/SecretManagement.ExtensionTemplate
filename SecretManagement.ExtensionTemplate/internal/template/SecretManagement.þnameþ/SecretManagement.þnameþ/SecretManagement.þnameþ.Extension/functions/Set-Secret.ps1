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
    $AdditionalParameters = @{} + $AdditionalParameters
    if ($AdditionalParameters.Verbose) { $VerbosePreference = 'continue' }
    $updateParam = $PSBoundParameters | ConvertTo-PSFHashtable #-Exclude 'Secret'
    # if ($Secret -is [securestring]) {
    #     $updateParam.NewPassword = $Secret
    # }
    # elseif ($Secret -is [pscredential]) {
    #     $updateParam.NewPassword = $Secret.password
    #     $updateParam.NewUsername = $Secret.Username
    # }
    Write-PSFMessage "#Setting secret with `$updateParam=$($updateParam|ConvertTo-Json -Compress)"
    Update-NetwrixContainer @updateParam
    Wait-PSFMessage
    return $true
}

