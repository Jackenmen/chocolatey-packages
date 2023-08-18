﻿$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName = $env:ChocolateyPackageName
  file64      = "$toolsDir\ClavierSetup.exe"
  silentArgs  = '/S'
}

Install-ChocolateyInstallPackage @packageArgs
