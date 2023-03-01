# Functions.SharedInternal

This is the folder where internal functions go which will be imported from the main
and the extension module.

The module will pick up all .ps1 files recursively. If the module is build with
'vsts-build.ps1' the content of all *.ps1 files is copied into the *.psm1 file.