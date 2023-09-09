$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$packageArgs = @{
  packageName     = $env:ChocolateyPackageName
  fileFullPath    = "$toolsDir\devd-0.9-windows32.zip"
  fileFullPath64  = "$toolsDir\devd-0.9-windows64.zip"
  destination     = $toolsDir
}

Get-ChocolateyUnzip @packageArgs
