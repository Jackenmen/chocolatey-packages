﻿$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName  
  fileType      = 'exe'
  file          = "$toolsDir\chirp-next-20230327-installer.exe"
  silentArgs    = '/S'
}

Install-ChocolateyInstallPackage @packageArgs
