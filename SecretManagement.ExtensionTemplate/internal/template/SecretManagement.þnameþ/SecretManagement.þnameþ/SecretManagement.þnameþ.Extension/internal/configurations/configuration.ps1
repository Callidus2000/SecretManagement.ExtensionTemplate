<#
This is an example configuration file

By default, it is enough to have a single one of them,
however if you have enough configuration settings to justify having multiple copies of it,
feel totally free to split them into multiple files.
#>

<#
# Example Configuration
Set-PSFConfig -Module 'SecretManagement.þnameþ.Extension' -Name 'Example.Setting' -Value 10 -Initialize -Validation 'integer' -Handler { } -Description "Example configuration setting. Your module can then use the setting using 'Get-PSFConfigValue'"
#>

Set-PSFConfig -Module 'SecretManagement.þnameþ.Extension' -Name 'Import.DoDotSource' -Value $false -Initialize -Validation 'bool' -Description "Whether the module files should be dotsourced on import. By default, the files of this module are read as string value and invoked, which is faster but worse on debugging."
Set-PSFConfig -Module 'SecretManagement.þnameþ.Extension' -Name 'Import.IndividualFiles' -Value $false -Initialize -Validation 'bool' -Description "Whether the module files should be imported individually. During the module build, all module code is compiled into few files, which are imported instead by default. Loading the compiled versions is faster, using the individual files is easier for debugging and testing out adjustments."

Set-PSFConfig -Module 'SecretManagement.þnameþ.Extension' -Name 'ConsoleLogging.enabled' -Value $true -Initialize -Validation 'bool' -Description "If set to `$true, Messages from the module will be displayed in the main console"
# Set-PSFConfig -Module 'SecretManagement.þnameþ.Extension' -Name 'ConsoleLogging.style' -Value 'CON: %Message%' -Initialize -Validation string -Description "What should be displayed in the console?"
# Set-PSFConfig -Module 'SecretManagement.þnameþ.Extension' -Name 'ConsoleLogging.style' -Value '%Tags%|%Level%|%Module%|%FunctionName%: %Message%' -Initialize -Validation string -Description "What should be displayed in the console?"
Set-PSFConfig -Module 'SecretManagement.þnameþ.Extension' -Name 'ConsoleLogging.style' -Value '[%Level%] %Message%' -Initialize -Validation string -Description "What should be displayed in the console?"
# Possible levels: Critical (1), Important / Output / Host (2), Significant (3), VeryVerbose (4), Verbose (5), SomewhatVerbose (6), System (7), Debug (8), InternalComment (9), Warning
#         (666) Either one of the strings or its respective number will do as input.
Set-PSFConfig -Module 'SecretManagement.þnameþ.Extension' -Name 'ConsoleLogging.MinLevel' -Value 1 -Initialize -Validation integer -Description "From which level starting on should messages be sent to the provider?"
Set-PSFConfig -Module 'SecretManagement.þnameþ.Extension' -Name 'ConsoleLogging.MaxLevel' -Value 1 -Initialize -Validation integer -Description "Up to which level should messages be sent to the provider?"
