$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$packageArgs = @{
  packageName  = $env:ChocolateyPackageName
  fileFullPath = "$toolsDir\ucon64-2.2.2-win32-vc-bin.zip"
  destination  = $toolsDir
}

Get-ChocolateyUnzip @packageArgs
