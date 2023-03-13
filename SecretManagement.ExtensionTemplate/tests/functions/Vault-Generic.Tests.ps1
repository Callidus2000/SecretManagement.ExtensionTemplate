Describe "Generic tests of pre-Configured vault 'TemplateTester'" {
    Context "Vault is already setup"{
        BeforeAll {
            $vaultName = 'TemplateTester'
            $secretText = "$(Get-Date)"
            $myNewSecret = ConvertTo-SecureString $secretText -AsPlainText
            [pscredential]$myNewCred = New-Object System.Management.Automation.PSCredential ('SomeUser', $myNewSecret)

        }
        It "Check if Vault $vaultName is registered" {
            # Write-PSFMessage -Level Host "Test vault $vaultName"
            Get-SecretVault $vaultName |Should -not -BeNullOrEmpty
        }
        It "Check if Vault $vaultName Contains the seccret foo" {
            # Write-PSFMessage -Level Host "Test vault $vaultName"
            {Get-Secret -Vault $vaultName  Foo -ErrorAction Stop} |Should  -Throw
        }
        It "Check setting a SecureString" {
            # Write-PSFMessage -Level Host "Test vault $vaultName"
            Set-Secret -Vault $vaultName -Name Foo  -Secret $myNewSecret
            Get-Secret -Vault $vaultName  Foo |Should -not -BeNullOrEmpty
            Get-Secret -Vault $vaultName  Foo |Should -BeOfType [SecureString]
            Get-Secret -Vault $vaultName  Foo |Should -Not -BeOfType [pscredential]
        }
        It "Check setting a pscredential" {
            # Write-PSFMessage -Level Host "Test vault $vaultName"
            {Get-Secret -Vault $vaultName  MyCred -ErrorAction Stop} | Should -Throw
            Set-Secret -Vault $vaultName -Name MyCred  -Secret $myNewCred
            Get-Secret -Vault $vaultName  MyCred | Should -not -BeNullOrEmpty
            Get-Secret -Vault $vaultName  MyCred | Should -Not -BeOfType [SecureString]
            Get-Secret -Vault $vaultName  MyCred | Should -BeOfType [pscredential]
        }
        It "Check getting secretInfos"{
            $info=Get-SecretInfo -Vault $vaultName  MyCred
            $info | Should -not -BeNullOrEmpty
            # $Metadata
            $info.Metadata.ContainsKey("info") | Should -betrue
            $info.Metadata.Keys.Count | Should -Be 1
        }
        It "Check Case Sensitivity of HashTables - Hopefully will be fixed in the future"{
            $info=Get-SecretInfo -Vault $vaultName  MyCred
            $info.Metadata.ContainsKey("info") | Should -betrue
            $info.Metadata.ContainsKey("INFO") | Should -beFalse
            $info.Metadata.ContainsKey("Info") | Should -beFalse
        }
        It "Setting SecretInfos" {
            Set-SecretInfo -Vault $vaultName -Name Foo -Metadata @{thisIs="useless"}
            $info = Get-SecretInfo -Vault $vaultName  Foo
            $info.Metadata.ContainsKey("info") | Should -beFalse
            $info.Metadata.ContainsKey("thisIs") | Should -betrue
            $info.Metadata.thisIs | Should -be "useless"
        }
    }
}