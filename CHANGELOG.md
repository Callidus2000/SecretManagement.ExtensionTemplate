# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.2.0] - 2023-03-13
### Added
- Basic pester tests
  - General tests from PSModuleDevelopment
  - Functional tests by creating a Pester Test extension and trying basic functions on a derived vault
- New Chapter 'Problems without workaround in the template'
## [1.1.2] - 2023-03-10
### Fixed
- Workflow run
## [1.1.1] - 2023-03-10
### Added
- Metadata in manifest for gallery
## [1.1.0] - 2023-03-10
### Added
- test\Start-þnameþRunspace.ps1  
 Helper for starting a new runspace with the current development state
- Working example code in basic functions
- Added RestartableSession to the RequiredModules
### Changed
- Search'n'Replace of þnameþ against long versions
- README.md expanded a lot
## [1.0.3] - 2023-03-06
### Fixed
 - Missing dependency to PSModuleDelopment added
## [1.0.2] - 2023-03-06
### Fixed
 - CI/CD Workflow permissions
## [1.0.1] - 2023-03-06
### Added
 - CHANGELOG.md
 - GitVersion.yml
### Changed
 - Configuration module names
## [1.0.0] - 2023-03-03
First Release
[Unreleased]: https://github.com/Callidus2000/SecretManagement.ExtensionTemplate/compare/v1.2.0..HEAD
[1.2.0]: https://github.com/Callidus2000/SecretManagement.ExtensionTemplate/compare/v1.1.2..v1.2.0
[1.1.2]: https://github.com/Callidus2000/SecretManagement.ExtensionTemplate/compare/v1.1.1..v1.1.2
[1.1.1]: https://github.com/Callidus2000/SecretManagement.ExtensionTemplate/compare/v1.1.0..v1.1.1
[1.1.0]: https://github.com/Callidus2000/SecretManagement.ExtensionTemplate/compare/v1.0.3..v1.1.0
[1.0.3]: https://github.com/Callidus2000/SecretManagement.ExtensionTemplate/compare/v1.0.2..v1.0.3
[1.0.2]: https://github.com/Callidus2000/SecretManagement.ExtensionTemplate/compare/v1.0.1..v1.0.2
[1.0.1]: https://github.com/Callidus2000/SecretManagement.ExtensionTemplate/compare/v1.0.0..v1.0.1