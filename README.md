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
* [psframework](https://github.com/PowershellFrameworkCollective/psframework)

Without Fred's PSModuleDevelopment module neither the Netwrix nor this module would have been created. This module uses his templating engine and contains a mixture of two already existing templates.

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

As a result you now have the sub directory 'SecretManagement.OctoPass' which contains an extension module suitable for SecretManagement.

## Special included workarounds
- Shared internal functions
- Unterscheiden zwischen installierter und Dev-Nutzung (config.ps1)
- $AdditionalParameters = @{} + $AdditionalParameters
- Wait-PSFMessage before throw
- RSSession
- Dedicated Console Appender


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

