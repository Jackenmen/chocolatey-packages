﻿$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName = $env:ChocolateyPackageName  
  file        = "$toolsDir\wings-2.3.exe"    
  file64      = "$toolsDir\wings-x64-2.3.exe"    
  silentArgs  = '/S'
}

Install-ChocolateyInstallPackage @packageArgs
Write-Warning "OpenGL 2.1 for Windows is needed to launch Wings3D. See https://www.khronos.org/opengl/wiki/Getting_Started#Downloading_OpenGL"
