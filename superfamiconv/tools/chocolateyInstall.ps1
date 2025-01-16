$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileFullPath64 = "$toolsDir\superfamiconv_win64_v0.11.0.zip"
  destination    = $toolsDir
}

Get-ChocolateyUnzip @packageArgs
