function Invoke-SMETemplate {
    <#
    .SYNOPSIS
    Helper for creating a SecretManagement Extension module.

    .DESCRIPTION
    Helper for creating a SecretManagement Extension module.

    .PARAMETER NewExtensionName
    The name of the extension. Will result in a module names 'SecretManagement.$NewExtensionName'

    .PARAMETER FunctionPrefix
    Prefix for functions exported from the main module.
    'MySecret' will e.g. create a 'Register-MySecretVault.ps1'.

    .PARAMETER OutPath
    Where should the new module be saved? A subfolder named '' will be created.

    .PARAMETER CompileTemplates
    Should the templates be compiled before usage? Needed for development.

    .EXAMPLE
    Invoke-SMETemplate -NewExtensionName MyWarden -FunctionPrefix MV

    Will create a complete module structure SecretManagement.MyWarden


    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory)]
        [String]$NewExtensionName,
        [parameter(Mandatory)]
        [string]$FunctionPrefix,
        $OutPath = (Get-Location).Path,
        [switch]$CompileTemplates
    )
    if ($CompileTemplates) {
        $templateSource = Join-Path $moduleRoot 'internal\template'
        $templateDestination = Join-Path $moduleRoot 'compiledTemplates'
        $manifest = Join-Path $moduleRoot "SecretManagement.ExtensionTemplate.psd1"
        $manifestData = Import-PowerShellDataFile $manifest
        $moduleVersion = $manifestData.ModuleVersion

        Write-PSFMessage -Level Important "Using moduleRoot '$moduleRoot'"
        Write-PSFMessage -Level Important "Using templateSource '$templateSource'"
        Write-PSFMessage -Level Important "Using templateDestination '$templateDestination'"
        Write-PSFMessage -Level Important "Using moduleVersion '$moduleVersion'"
        Remove-Item -Path "$templateDestination\*.xml" -Verbose
        New-PSMDTemplate -TemplateName SecretManagement.Extension -OutPath $templateDestination -ReferencePath $templateSource -Force -Debug # -Version $moduleVersion
    }
    Invoke-PSMDTemplate SecretManagement.Extension -Parameters @{
        name           = $NewExtensionName
        Description    = "SecretManagement module for accessing $NewExtensionName vaults"
        functionPrefix = $FunctionPrefix
    } -OutPath $OutPath -NoFolder
}