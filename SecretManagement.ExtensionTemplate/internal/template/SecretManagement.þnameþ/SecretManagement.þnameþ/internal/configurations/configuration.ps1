<#
This is an example configuration file

By default, it is enough to have a single one of them,
however if you have enough configuration settings to justify having multiple copies of it,
feel totally free to split them into multiple files.
#>

<#
# Example Configuration
Set-PSFConfig -Module 'þnameþ' -Name 'Example.Setting' -Value 10 -Initialize -Validation 'integer' -Handler { } -Description "Example configuration setting. Your module can then use the setting using 'Get-PSFConfigValue'"
#>

Set-PSFConfig -Module 'þnameþ' -Name 'Import.DoDotSource' -Value $false -Initialize -Validation 'bool' -Description "Whether the module files should be dotsourced on import. By default, the files of this module are read as string value and invoked, which is faster but worse on debugging."
Set-PSFConfig -Module 'þnameþ' -Name 'Import.IndividualFiles' -Value $false -Initialize -Validation 'bool' -Description "Whether the module files should be imported individually. During the module build, all module code is compiled into few files, which are imported instead by default. Loading the compiled versions is faster, using the individual files is easier for debugging and testing out adjustments."

$currentPath = "$ModuleRoot\SecretManagement.þnameþ.psd1"
$latestInstalledModules = get-module SecretManagement.þnameþ -ListAvailable | Sort-Object version -Descending | Select-Object -ExpandProperty path -first 1
Write-PSFMessage "Checking if current module '$currentPath' against latest installed version '$latestInstalledModules'"
if ($currentPath -eq $latestInstalledModules) {
    Set-PSFConfig -Module 'SecretManagement.þnameþ' -Name 'InterActiveRegister.modulepath' -Value "SecretManagement.þnameþ" -Initialize -Validation string -Description "Module Path for Vault Registration, Name of the module as latest installed version"
}
else {
    Set-PSFConfig -Module 'SecretManagement.þnameþ' -Name 'InterActiveRegister.modulepath' -Value $currentPath -Initialize -Validation string -Description "Module Path for Vault Registration, development point to local non installed PSM1"
}