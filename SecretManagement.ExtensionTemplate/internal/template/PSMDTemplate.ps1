@{
	TemplateName         = "SecretManagement.Extension"
	# Version              = ([Version]"1.1.1.0")
	AutoIncrementVersion = $true
	Tags                 = 'module', 'psframework'
	Author               = 'Sascha Spiekermann'
	Description          = 'Extension module for Secret Management.'
	Exclusions           = @("PSMDInvoke.ps1", ".PSMDDependency") # Contains list of files - relative path to root - to ignore when building the template
	Scripts              = @{
		guid         = {
			[System.Guid]::NewGuid().ToString()
		}
		guidRootModule         = {
			[System.Guid]::NewGuid().ToString()
		}
		guidExtension         = {
			[System.Guid]::NewGuid().ToString()
		}
		date         = {
			Get-Date -Format "yyyy-MM-dd"
		}
		year         = {
			Get-Date -Format "yyyy"
		}
		dynamicscript_394432 = {
		 Get-Date -Format 'yyyy-MM-dd'
		}
		psfversion          = {
			(Get-Module PSFramework).Version.ToString()
		}
		psframework          = {
			(Get-Module PSFramework).Version.ToString()
		}
		secretManagementVersion          = {
			(Get-Module Microsoft.Powershell.SecretManagement -ListAvailable | Sort-Object -Property Version | Select-Object -last 1).Version.ToString()
		}
		testfolder   = {

		}
		pesterconfig = {

		}
		dynamicscript_844112 = {
		 Get-Date -Format 'yyyy-MM-dd'
		}
	}
}