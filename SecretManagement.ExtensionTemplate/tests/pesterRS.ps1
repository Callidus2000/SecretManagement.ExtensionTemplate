param (
    $TestGeneral = $true,

    $TestFunctions = $true,

    [ValidateSet('None', 'Normal', 'Detailed', 'Diagnostic')]
    [Alias('Show')]
    $Output = "None",

    $Include = "*",

    $Exclude = ""
)
$pesterParam=$PSBoundParameters|ConvertTo-PSFHashtable -IncludeEmpty -Inherit
if ($pesterParam.ContainsKey('TestFunctions') -eq $false){
    $pesterParam.TestFunctions=$true
}
Enter-RSSession -OnStartArgumentList @($PSScriptRoot, $pesterParam) -onstart {
    param($scriptRoot, $pesterParam)
    $pathToPester = "$scriptRoot\pester.ps1"
    Write-PSFMessage -Level Host "Starting $pathToPester with $($pesterParam|ConvertTo-Json -Compress)"
    Import-Module -Force $scriptRoot\..\SecretManagement.ExtensionTemplate.psd1

    # $null = New-Item -Path "$scriptRoot\..\.." -Name TestResults -ItemType Directory -Force
    # $testResultPath=(Get-Item -Path "$scriptRoot\..\..\TestResults").FullName
    # if (Test-Path "$testResultPath\SecretManagement.PesterValidate"){
    #     Remove-Item "$testResultPath\SecretManagement.PesterValidate" -Recurse -Force
    # }
    # Invoke-SMETemplate -NewExtensionName PesterValidate -CompileTemplates -OutPath $testResultPath -FunctionPrefix MP

    & $pathToPester @pesterParam
} -onend {
}