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

  <h3 align="center">SecretManagement PowerShell Extension for Netwrix PasswordSecure</h3>

  <p align="center">
    This Powershell Module is an extension to the <a href="https://github.com/PowerShell/SecretManagement">Microsoft Secret Management Module</a>
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

This Powershell Module is a template for building your own extension to the [Microsoft Secret Management Module](https://github.com/PowerShell/SecretManagement) for accessing secrets stored somewhere.


### Built With

* [PSModuleDevelopment](https://github.com/PowershellFrameworkCollective/PSModuleDevelopment)
* [psframework](https://github.com/PowershellFrameworkCollective/psframework)



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

```Powershell
# Create a module by ....
```

## Special included workarounds
- Shared internal functions
- Unterscheiden zwischen installierter und Dev-Nutzung (config.ps1)
- $AdditionalParameters = @{} + $AdditionalParameters
- Wait-PSFMessage before throw
- RSSession
- Dedicated Console Appender

## Register a Secret Vault
To interact with a password server you have to register it as a SecretVault. For this task you've got multiple possibilities, ordered from "Simple, but non customizable" to "You have to know what you are doing, but then you may configure the weirdest scenarios".

### Use an interactive assistant
If you are using this module on a computer which has the Netwrix client software installed, you can invoke an interactive register service.
```Powershell
Register-NetwrixSecureVault -InterActive
```
![Out GridView Example](docs/img/interactive_choice.PNG)
After choosing an entry you will be asked which username should be used for connection.
#### Overwrite the vaultname
If you do not want to use the existing Database Name as a vault name you can overwrite it with the `VaultName` parameter:
```Powershell
Register-NetwrixSecureVault -VaultName SomeThingElse -InterActive
```
### Use the interactive part to create a manual command
If you add a `-WhatIf` to the interactive part the vault will not be registered but you get the instructions for manual registration:
```Powershell
Register-NetwrixSecureVault -InterActive -WhatIf
# shortened for user input
You may register the chosen vault later with the following command:
$registerParam=@{
  VaultParameters = @{
    Port = '11016'
    Database = 'PWS8_I'
    Server = 'integration.domain.com'
    UserName = 'maxmuster'
    version = '2.0.0'
  }
  ModuleName = 'SecretManagement.ExtensionTemplate'
  Name = 'PWS_Integration'
}
Register-SecureVault @registerParam
```

Of course you can define the necessary parameter completely manual.

### Use Register-SecretVault
```Powershell
$registerParam=@{
  VaultParameters = @{
    Database = 'PWS8_I'
    Server = 'integration.domain.com'
    UserName = 'maxmuster'
    #Port = '11016'
  }
  ModuleName = 'SecretManagement.ExtensionTemplate'
  Name = 'PWS_Integration'
}
Register-SecureVault @registerParam
```
The port is optional.
<!-- USAGE EXAMPLES -->
## Query secrets
Lets pretend you've got just three entries stored in your server: `foo`, `hubba` and `hubba` (yes, a dupe regarding the name within different containers).
```Powershell
Get-Secret -Name foo

UserName                     Password
--------                     --------
foo      System.Security.SecureString

Get-Secret -Vault $Vaultname -Name hubba
[Error] Multiple credentials found; Search with Get-SecretInfo and require the correct one by *.MetaData.id
Get-Secret: Unable to get secret hubba from vault PWSafeInt
Get-Secret: The secret hubba was not found.
```
Seen it? The SecretManagement Framework does not allow to query duplicate entries, in the concept (off-world) there rule uniqueness regarding the name attribute. As duplicate names can be used you have to acquire the GUID of the correct entry and query this record in particular

```Powershell
Get-SecretInfo -Name hubba |fl

Name      : Hubba [5dd937c4-b0a0-ed11-a876-005056bce948]
Type      : PSCredential
VaultName : PWS
Metadata  : {[userName, Foo], [id, 5dd937c4-b0a0-ed11-a876-005056bce948], [Beschreibung, Hubba], [memo, ]…}

Name      : Hubba [ef2fe11d-b0a0-ed11-a876-005056bce948]
Type      : PSCredential
VaultName : PWS
Metadata  : {[userName, hubba], [id, ef2fe11d-b0a0-ed11-a876-005056bce948], [Beschreibung, Hubba], [memo, ]…}

# Query the one with the username 'hubba'
Get-Secret ef2fe11d-b0a0-ed11-a876-005056bce948

UserName                     Password
--------                     --------
hubba    System.Security.SecureString
```

## Updating existing secret
For updating use `Set-Secret`:
```Powershell
Set-Secret -Secret (Get-Credential) -Name foo
```
Attention: If you use a `SecureString` secret only the password is updated, using a `PSCredential` secret updates the username, too.

## Creating a new Secret
For adding a new secret you also use Set-Secret - Sometimes in the future, as it's currently under development.
```Powershell
# Create an entry under the default OU with the default form
Set-Secret -Verbose -Vault $Vaultname -Secret $myNewSecret -Name "Cheeata"
# Create an entry under the OU 'API' with the default form
Set-Secret -Verbose -Vault $Vaultname -Secret $myNewSecret -Name "API\Cheeata 2"
# Create an entry under the default OU with the form 'Password'
Set-Secret -Verbose -Vault $Vaultname -Secret $myNewSecret -Name "API\Cheeata 3|Password"
```

## Setting additional entry fields
If the password form contain additional information/fields they can be set by using `Set-SecretInfo`.

Forms? OU? See [Internal concepts](#internal-concepts).

# Internal Concepts
The solution is not only focused on security but also on customizability. For understanding some configuration/usage scenarios you need to know the basics.

## Password Forms
The administrator of the server can configure multiple password forms which can be used by the regular user to store secrets in a standardized manner. Each named form defines named fields of different types. E.g. a regular credential form may consist of 'username' and 'password' fields while a form for a physical server adds information about the 'root ssh key' and the password for the BIOS or ILO interface. For the secret management extension it's necessary to know which fields belong directly to the secret itself or are just additional (meta) information which do not have to be kept secret.

You can configure which form should be used by default just by adding `-DefaultFormName` parameter to `Register-NetwrixSecureVault`. If this is omitted the form with the least amount of fields (and as second sorting level with the shortest name) will be used as default.

## Password Container
Every password entry is a container. Each password container can be derived from a password form or be built from ground up without any standard. The password container has child items which represent the named fields (see [Password Container](#password-container)).

## Organizational Units (OU)
All password containers are grouped in hierarchical groups called organizations. Each organization has a type: 'Group' (for sharing information between users) and 'User' (most times only permissions for the named user himself.)

You can configure which OU should be used by default just by adding `-DefaultOUName` parameter to `Register-NetwrixSecureVault`. If this is omitted the first OU sorted by name ascending will be used as default, 'Group' types preferred.


## Combining all together                                     
If the user wants to store a secret in to this solution he has to choose to which OU the new entry should belong (if no default is configured), which form to use and then he has to fill out all the necessary fields. If a secret is queried the extensions searches for an entry with the given name, tries to identify the base form of the container and them maps the field to the queried information type (credential, secret information, ..).


<!-- ROADMAP -->
# Roadmap
New features will be added if any of my scripts need it ;-)
## v1 - Released
- Get Access to stored secrets by best guess approach which data is stored where
## v2 - Released on 2023-02-27
The vaults are as customizable as the password storage. Therefor a system was developed which allows the configuration of provided password forms and field associations. To keep the effort for team/company usage as low as possible it will be possible to distribute this mapping information e.g. by GPO and registry settings.

# Further development/documentation - RoadMap behind the scenes

The main focus of this module is to get access to our internal Password Servers. As the system is quite easy to customize (see [Internal Concepts](#internal-concepts)) it might not be usable for your installation. If running into problems [open a new issue](https://github.com/Callidus2000/SecretManagement.ExtensionTemplate/issues), I try to look into it.

Regarding missing documentation like 'Mapping password form fields to secret information' (includes storing HashTables) I'll add it if asked for. Currently I'm the only user of this module, I don't know how many Enterprise Customers may be interested in it and therefor currently no one needs more examples/docs. Feel free to comment as an issue or reach out to me directly.

I cannot guarantee that no breaking change will occur as the development follows my internal DevOps need completely. Likewise I will not insert full documentation of all parameters as I don't have time for this copy&paste. Sorry. But major changes which classify as breaking changes will result in an increment of the major version. See [Changelog](SecretManagement.ExtensionTemplate/changelog.md) for information regarding breaking changes.

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

* [Friedrich Weinmann](https://github.com/FriedrichWeinmann) for his marvelous [PSModuleDevelopment](https://github.com/PowershellFrameworkCollective/PSModuleDevelopment) and [psframework](https://github.com/PowershellFrameworkCollective/psframework)





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

