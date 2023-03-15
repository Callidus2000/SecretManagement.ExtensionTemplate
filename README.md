<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Thanks again! Now go create something AMAZING! :D
***
-->

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![GPLv3 License][license-shield]][license-url]


<br />
<p align="center">
<!-- PROJECT LOGO
  <a href="https://github.com/Callidus2000/SecretManagement.ExtensionTemplate">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>
-->

  <h3 align="center">Template for PowerShell SecretManagement Extension</h3>

  <p align="center">
    This Powershell Module provides a template for an easy way to create own extension modules to the <a href="https://github.com/PowerShell/SecretManagement">Microsoft Secret Management Module</a>
    <br />
    <a href="https://github.com/Callidus2000/SecretManagement.ExtensionTemplate"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/Callidus2000/SecretManagement.ExtensionTemplate/issues">Report Bug</a>
    ·
    <a href="https://github.com/Callidus2000/SecretManagement.ExtensionTemplate/issues">Request Feature</a>
  </p>
</p>



<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h1 style="display: inline-block">Table of Contents</h1></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#use-cases-or-why-was-the-module-developed">Use-Cases - Why was this module created?</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
# About The Project

This Powershell Module is a template for building your own extension to the [Microsoft Secret Management Module](https://github.com/PowerShell/SecretManagement) for accessing secrets stored somewhere. It was created after building the [Netwrix Password Secure](https://github.com/Callidus2000/SecretManagement.NetwrixPasswordSecure) extension and has the focus to provide an easy access to best practises.


### Built With

* [PSModuleDevelopment](https://github.com/PowershellFrameworkCollective/PSModuleDevelopment)
* [PSFramework](https://github.com/PowershellFrameworkCollective/psframework)
* [RestartableSession](https://github.com/mdgrs-mei/RestartableSession)

Without Fred's PSModuleDevelopment module neither the Netwrix nor this module would have been created. This module uses his templating engine and contains a mixture of two already existing templates.

The **RestartableSession** module is a special case: I've added it to the required modules list even the module itself does not need it.
Why?
Without it I'd never survived the debugging madness of the multi-runspace-model of SecretManagement itself. And I've included this as a best practice in the template for you. Trust me, it's invaluable.


<!-- GETTING STARTED -->
# Getting Started

To get a local copy up and running follow these simple steps.

## Prerequisites

- Powershell 7.x (Core) (If possible get the latest version)  
  Maybe it's working under 5.1, just did not test it

## Installation

The releases are published in the Powershell Gallery, therefor it is quite simple:
```powershell
  install-module SecretManagement.ExtensionTemplate -Scope CurrentUser
```

If you want to create a new module for (fictional) the password solution OctoPass in the current directory use
```Powershell
Invoke-SMETemplate -NewExtensionName OctoPass  -FunctionPrefix OP
```

As a result you now have the sub directory 'SecretManagement.OctoPass' which contains an extension module suitable for SecretManagement. If not already done I'd advise to read [the official documentation](https://github.com/PowerShell/SecretManagement), especially [about the architecture](https://github.com/PowerShell/SecretManagement/blob/master/Docs/ARCHITECTURE.md). If possible I'd like to not copy basic info to this readme.

# Special included workarounds
Some of the characteristics of the module can send you to the madhouse faster than you would like. A few of them are minor nuisance which has to be known, others are rather nightmares which haunt your whole development session.

The following chapters describe the problems and how either
- Is dealt with in the template,
- can be avoided in the developing phase or
- you yourself can avoid while implementing the backend code

## Dedicated Runspace
[Described/Mentioned in the architecture overview](https://github.com/PowerShell/SecretManagement/blob/master/Docs/ARCHITECTURE.md#vault-extension-hosting) the biggest developing nightmare is introduced with one sentence:

*Extension vault modules are hosted in a separate PowerShell runspace session that is separate from the current user PowerShell session.*

This design principle may be required to achieve a few things but it causes a bunch of sub problems you need to know how to get worked with.

### Displaying error messages / communicating with the end user
As the functions of the new Extension do not run within the regular user runspace it is not guaranteed that Write-Host/-Debug etc. will reach the user. The template makes heavy use of `Write-PSFMessage`. This logging function has a many benefits, like
- it works over multiple runspaces,
- verbosity can be defined by the `-Level` parameter (Host/Verbose/Debug corresponding to the different `Write-*` functions),
- the messages can be written to multiple destinations just by external configuration

In the default configuration in the template all logging message will not only be displayed regularly (defined by verbosity) but also added to a logfile. To get the location of the logfiles type
```Powershell
Get-PSFConfigValue PSFramework.Logging.FileSystem.LogPath
```
If you are expecting a message to be written and it does not appear: Look at the logs, sometimes the SecretManagement runspace thing is a black hole which captures all...

If you throw an exception and want to make sure that the message is delivered use the following snippet (adapted texts):
```Powershell
Write-PSFMessage -Level Error 'Multiple credentials found; Search with Get-SecretInfo and require the correct one by *.MetaData.id'
Wait-PSFMessage   # Make sure the logging queue is flushed
throw 'Multiple credentials found; Search with Get-SecretInfo and require the correct one by *.MetaData.id'
```
The template uses a specific console appender (configured in `SecretManagement.þnameþ\SecretManagement.þnameþ\SecretManagement.þnameþ.Extension\internal\scripts\console_logging.ps1`) which logs warnings or worse to the console. The `Wait-PSFMessage` makes sure that the logging queue is flushed (therefor the message is written before stopping the function with the exception).

Shortest advice: **Stick to the PSFramework logging and ignore classic output functions**

### Query input from the user
As the architecture docs say *There is one shared component between the extension vault session and the current user session, and that is the PowerShell host (PSHost)*. To query e.g. the password for unlocking you could use
```Powershell
$password=$Host.ui.ReadLineAsSecureString()
```
Of course you could also use the `$host.UI.Write*` functions for output, but stay with the PSFMessage stuff, trust Fred an me ;-)

### Importing again is not enough
Normally, my developing cycle looks somewhat like this:
```Powershell
Import-Module MyModule.psd1 -Force
# try something which does not work
# fix/change the module code
Import-Module MyModule.psd1 -Force
# try again
```
As the vaults are configured with the path to the extension module and are contained in a different runspace, `Import-Module -Force` does not do the trick. You would need to start a new session and start all the initialization again. That's a black whole for workforce time...

That is where the `RestartableSession` module comes to the rescue (another way to achieve it is described below as [Get Rid of the SecretManagement - FAST](#alternative-get-rid-of-the-secretmanagement---fast)). If you're e.g. creating an extension for 'MyWarden' the following file is created:
```Powershell
#SecretManagement.MyWarden\test\Start-MyWardenRunspace.ps1


[CmdletBinding()]
param(
    $VaultConfig = 'MyWardenDemo',
    [switch]$NoWatcher
)
$vaultsParameter = @{
    MyWardenDemo =
    @{
        vaultName = "MyWardenDemo"
        server    = "localhost"
        UserName  = $env:USERNAME
        password  = ConvertTo-SecureString -AsPlainText -String "THIS_SHOULDBE_SWAPPED"  # Please use something else like 'Get-Credential' ;-)
    }
}
Write-Host "`$PSScriptRoot=$PSScriptRoot"
# $PSScriptRoot has to be provided as a parameter as it's not available in the scriptblock
Enter-RSSession -OnStartArgumentList @($vaultsParameter.$VaultConfig, $PSScriptRoot) -onstart {
    param($vaultParam,$PSSC)
    $vp = $vaultParam
    $vaultName = $vaultParam.vaultName
    $myNewSecret = ConvertTo-SecureString "$(Get-Date)" -AsPlainText
    [pscredential]$myNewCred = New-Object System.Management.Automation.PSCredential ('SomeUser', $myNewSecret)
    Write-PSFMessage -Level Host "Rember: You can access the following default variables:"
    Write-PSFMessage -Level Host (@{
            '$vp'          = "Currently used vault config parameters"
            '$vaultName'   = "The current configured vault"
            '$myNewSecret' = "A new SecureString containing the current time"
            '$myNewCred'   = "A new Credential using `$myNewSecret"
        } | Format-Table -Wrap | Out-String)
    $additionalParameter = $vaultParam | ConvertTo-PSFHashtable -Exclude vaultName, password
    Write-PSFMessage "Register Vault $vaultName with additional parameters $($additionalParameter|ConvertTo-Json -Compress  )"
    $modulePath = join-path (split-path $PSSC) "SecretManagement.MyWarden"
    $manifestPath = Join-Path $modulePath "SecretManagement.MyWarden.psd1"
    Write-PSFMessage "Using modulePath '$modulePath'"
    Import-Module -force $manifestPath -Verbose
    Register-SecretVault -Name $vaultName -ModuleName $manifestPath -VaultParameters $additionalParameter
    Unlock-SecretVault -Name $vaultName -Password $vaultParam.password -Verbose
    if ($NoWatcher) {
        Write-PSFMessage -Level Host "Use 'Restart-RSSession' to restart  the session."
    }
    else {
        Write-PSFMessage -Level Host "Any File Change within '$modulePath' will lead to a restart of the session."
        Write-PSFMessage -Level Host "To disable this use 'Start-MyWardenRunspace.ps1 -NoWatcher'"
        Start-RSRestartFileWatcher -Path "$modulePath" -IncludeSubdirectories
    }
    @(
        "Example commands to test the new vault (for copy'n'paste)"
        #TODO Fill in live names of already stored secret names ;-)
        "# Get-Secret -Vault `$Vaultname -Name foo"
        "# Get-Secret -Vault `$Vaultname -Name MyFirstPassword -Verbose"
        "# Get-SecretInfo -Vault `$Vaultname -Name foo"
        "# Get-SecretInfo -Vault `$Vaultname -Name MyFirstPassword"
        "# Set-Secret -Verbose -Vault `$Vaultname -Secret `$myNewSecret -Name foo"
        "# Set-Secret -Verbose -Vault `$Vaultname -Secret `$myNewSecret -Name Hubba"
        "# Set-SecretInfo -Verbose -Vault `$Vaultname  -Name foo -Metadata @{Beschreibung='Notiz'}"
        '# Set-Secret -Verbose -Vault $Vaultname -Secret $myNewCred -Name "NewFoo"') | ForEach-Object { Write-PSFMessage -Level Host $_ }
} -onend {
    Write-PSFMessage -Level Host "Removing all vaults which use a module named like '*MyWarden*'"
    Get-SecretVault | Where-Object modulepath -like '*MyWarden*' | Unregister-SecretVault
}
```

The main trick is the cmdlet `Enter-RSSession`. It starts a unique session which has some initialization done in the `-OnStart` scriptblock:

- Determine the module path
- Import the module
- Register a new vault with the current module path
- Initialize some helper variables and inform the user about them
- Unlock the vault (**make sure to obtain a real unlock password in a secure manner**)
- Start a Filewatcher

The file watcher restarts the session automatically if a file is changed. So while developing start the script, make changes and the automatically restarted session will reflect it. Exiting the session (`Exit-RSSession`) will remove the previously registered test vaults.

### Alternative: Get Rid of the SecretManagement - FAST
I've opened [issue 206](https://github.com/PowerShell/SecretManagement/issues/206) regarding the runspace problem and got a brilliant alternative by [llewellyn-marriott](https://github.com/llewellyn-marriott) for my [Importing again is not enough](#importing-again-is-not-enough) problem. The following code finds the used runspace and kills it:
```Powershell
# Get the runspace field
$RunspaceField = (([Microsoft.PowerShell.SecretManagement.SecretVaultInfo].Assembly.GetTypes() | Where-Object Name -eq 'PowerShellInvoker').DeclaredFields | Where-Object Name -eq '_runspace')
# Get current runspace value and dispose of it
$RunspaceValue = $RunspaceField.GetValue($null)
if($NULL -ne $RunspaceValue) {
    $RunspaceValue.Dispose()
}
# Set the runspace field to null
$RunspaceField.SetValue($null, $null)
```
It may have side effects (like killing SecretManagement runspace and therefor all vault states (you need e.g. to unlock them again)) but it does the job and needs milliseconds instead of multiple seconds. That trick is *fast*.

## Smaller workarounds
The following chapters describe headaches but no nightmares.
### Shared internal functions
If you need an internal function available in the wrapper- and in the extension module simply put it into the `SecretManagement.þnameþ\SecretManagement.þnameþ\SecretManagement.þnameþ.Extension\functions.sharedinternal` folder.
### Differentiate between installed module and development version
If you use the supplied `Register-þfunctionPrefixþSecureVault` function for registering the vault it uses the name of the module if the current path hints to an installed version or the full path otherwise. This way you can use the specific version you are just developing or the general (and therefor latest) version of the installed module.

### AdditionalParameters are provided case sensitive
The `-AdditionalParameters` HashTable is delivered as a case sensitive HashTable ([issue 208](https://github.com/PowerShell/SecretManagement/issues/208)). As regular ones are not case sensitive and the user may configure the parameter `userName` or `username` it quickly leads to unexpected errors. In the demo code this is handled with
```Powershell
$AdditionalParameters = @{} + $AdditionalParameters
```
## Problems without workaround in the template
### Get-Secret: To Throw or Not To Throw
In v1.2.0 I've added a pester test case which
- Creates a SecretManagement.PesterValidate module
- Adds a vault with this module
- Performs small tests.

Everything worked fine on my Windows Dev System, but the validation failed running in a GitHub action.
`Get-Secret NotExistingName` behaves differently under Windows/Linux: running Windows it `returns $null`, running Linux it throws an exception.
```Powershell
Get-Secret -Vault $vaultName  Foo |Should -BeNullOrEmpty  # Works on Windows
Get-Secret -Vault $vaultName  Foo |Should -Throw  # Works on Linux/Ubuntu
{Get-Secret -Vault $vaultName  Foo -ErrorAction Stop} |Should  -Throw  # Works on both
```

### Get-SecretInfo: "There may only be one" (per vault)
It is mentioned in the docs that `Get-Secret` returns *one* secret at a time. Ok, its logical. `Get-SecretInfo` should return an array of `[SecretInformation]` objects. So the second one is meant e.g. for searching and the first for retrieving the main goods.

If you've got multiple vaults which contain entries with the same name (simple test: Register the same vault twice under different names) `Get-SecretInfo` returns them all:

```Powershell
> Get-SecretInfo -Name hubba

Name  Type         VaultName
----  ----         ---------
hubba PSCredential MyWardenDemo

> Register-SecretVault -Name "$vaultName.2" -ModuleName $manifestPath
> Get-SecretInfo -Name hubba

Name  Type         VaultName
----  ----         ---------
hubba PSCredential MyWardenDemo
hubba PSCredential MyWardenDemo.2
```

But what happens if your vault supports multiple secrets with the same name? Maybe side-by-side or contained in different folders?  Then `Get-SecretInfo` has a bad day and does not return anything.
```Powershell
> Get-SecretInfo -Vault MyWardenDemo -Name foo
Get-SecretInfo: An item with the same key has already been added. Key: [Foo, Microsoft.PowerShell.SecretManagement.SecretInformation]
```
This is filed as [issue 95](https://github.com/PowerShell/SecretManagement/issues/95) since 2021. If your vault is able to store multiple entries with the same name you will most likely need a workaround for it. In my Netwrix module I've added the ID of each entry to the name if the name occurs multiple times. The ID can be used for retrieval, too.
```Powershell
# Build $tempList with the real infos and search for duplicate names
$entriesWithDuplicateNames = $tempList | Group-Object -Property name | Where-Object count -gt 1
foreach ($group in $entriesWithDuplicateNames) {
    Write-PSFMessage "The Secret with the name $($group.Name) occurs $($group.Count) times, adding the GUID to the name"
    foreach ($info in $group.Group) {
        $info.name += " [$($info.id)]"
    }
}
```
<!-- ROADMAP -->
# Roadmap
New features/changes will be added if somebody needs it or stumbles over a bug.

I've created it purely to write down insights which caused a lot of headaches while writing my own module. If no one uses the template and if I do not stumble over the need for another vault extension the template might never change again.

See the [open issues](https://github.com/Callidus2000/SecretManagement.ExtensionTemplate/issues) for a list of proposed features (and known issues).

If you need a special function feel free to contribute to the project.

<!-- CONTRIBUTING -->
# Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**. For more details please take a look at the [CONTRIBUTE](docs/CONTRIBUTING.md#Contributing-to-this-repository) document

Short stop:

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


# Limitations
* Maybe there are some inconsistencies in the docs, which may result in a mere copy/paste marathon from my other projects

<!-- LICENSE -->
# License

Distributed under the GNU GENERAL PUBLIC LICENSE version 3. See `LICENSE.md` for more information.

<!-- CONTACT -->
# Contact


Project Link: [https://github.com/Callidus2000/SecretManagement.ExtensionTemplate](https://github.com/Callidus2000/SecretManagement.ExtensionTemplate)



<!-- ACKNOWLEDGEMENTS -->
# Acknowledgements

* [Friedrich Weinmann](https://github.com/FriedrichWeinmann) for his marvelous [PSModuleDevelopment](https://github.com/PowershellFrameworkCollective/PSModuleDevelopment) and [psframework](https://github.com/PowershellFrameworkCollective/psframework). My own extension and my template are build on base of his templates.
* [mdgrs-mei](https://github.com/mdgrs-mei) for his invaluable [RestartableSession](https://github.com/mdgrs-mei/RestartableSession) module. Without it I'd never survived the debugging madness of the multi-runspace-model of SecretManagement itself. And that would have killed my module and this template directly in the beginning.
* [llewellyn-marriott](https://github.com/llewellyn-marriott) for the code for `Reset-SMERunspace`.




<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/Callidus2000/SecretManagement.ExtensionTemplate.svg?style=for-the-badge
[contributors-url]: https://github.com/Callidus2000/SecretManagement.ExtensionTemplate/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/Callidus2000/SecretManagement.ExtensionTemplate.svg?style=for-the-badge
[forks-url]: https://github.com/Callidus2000/SecretManagement.ExtensionTemplate/network/members
[stars-shield]: https://img.shields.io/github/stars/Callidus2000/SecretManagement.ExtensionTemplate.svg?style=for-the-badge
[stars-url]: https://github.com/Callidus2000/SecretManagement.ExtensionTemplate/stargazers
[issues-shield]: https://img.shields.io/github/issues/Callidus2000/SecretManagement.ExtensionTemplate.svg?style=for-the-badge
[issues-url]: https://github.com/Callidus2000/SecretManagement.ExtensionTemplate/issues
[license-shield]: https://img.shields.io/github/license/Callidus2000/SecretManagement.ExtensionTemplate.svg?style=for-the-badge
[license-url]: https://github.com/Callidus2000/SecretManagement.ExtensionTemplate/blob/master/LICENSE

