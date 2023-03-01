# TODO Alternative logging to be created
Write-PSFMessage "Configure Console Logging"
if (Get-PSFConfigValue -FullName 'SecretManagement.þnameþ.Extension.ConsoleLogging.enabled' -Fallback $false) {
    $providerParam=@{
        Name="console"
        Enabled=$true
        style=Get-PSFConfigValue -FullName 'SecretManagement.þnameþ.Extension.ConsoleLogging.style'
        MinLevel=Get-PSFConfigValue -FullName 'SecretManagement.þnameþ.Extension.ConsoleLogging.MinLevel'
        MaxLevel=Get-PSFConfigValue -FullName 'SecretManagement.þnameþ.Extension.ConsoleLogging.MaxLevel'
        InstanceName = 'SecretManagement.þnameþ.console'
    }
    Write-PSFMessage "Configure Console Logging with Param=$($providerParam|ConvertTo-Json -Compress)"
    Set-PSFLoggingProvider @providerParam -IncludeModules 'SecretManagement.þnameþ.Extension'

}else{
    Write-PSFMessage "NOT Configure Console Logging"
}
