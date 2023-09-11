$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$packageArgs = @{
  packageName     = $env:ChocolateyPackageName
  fileFullPath64  = "$toolsDir\SuperFamiconv-v0.9.2-win_x64.zip"
  destination     = $toolsDir
}

Get-ChocolateyUnzip @packageArgs
