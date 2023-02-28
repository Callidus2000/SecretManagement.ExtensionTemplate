@{
	TemplateName = "PSFProject"
	Version = ([Version]"1.3.3")
	Tags = 'module','psframework'
	Author = "Friedrich Weinmann"
	Description = "PowerShell Framework based project scaffold"
	year = {
		
			Get-Date -Format "yyyy"
		
	}

	guid2 = {
		
			[System.Guid]::NewGuid().ToString().ToUpper()
		
	}

	testfolder = {
		
			@'
Write-PSFMessage -Level Important -Message "Creating test result folder"
$null = New-Item -Path "$PSScriptRoot\..\.." -Name TestResults -ItemType Directory -Force
'@
		
	}

	guid = {
		
			[System.Guid]::NewGuid().ToString()
		
	}

	guid3 = {
		
			[System.Guid]::NewGuid().ToString().ToUpper()
		
	}

	psframework = {
		
			(Get-Module PSFramework).Version.ToString()
		
	}

	date = {
		
			Get-Date -Format "yyyy-MM-dd"
		
	}

	pesterconfig = {
		
'$config.TestResult.Enabled = $true'
		
	}

	guid4 = {
		
			[System.Guid]::NewGuid().ToString().ToUpper()
		
	}

	dynamicscript_844112 = {
		 Get-Date -Format 'yyyy-MM-dd' 
	}
}