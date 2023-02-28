[cmdletbinding()]
param(

)
$moduleRoot = join-path -Path ( (Split-Path $PSScriptRoot)) -ChildPath 'SecretManagement.ExtensionTemplate'
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
