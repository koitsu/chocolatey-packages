# Based on sources:
# https://github.com/chocolatey-community/chocolatey-packages/blob/master/automatic/sysinternals/tools/chocolateyInstall.ps1
# https://github.com/chocolatey-community/chocolatey-packages/blob/master/automatic/curl/tools/chocolateyInstall.ps1
# https://github.com/chocolatey-community/chocolatey-packages/blob/master/automatic/wget/tools/chocolateyinstall.ps1

$ErrorActionPreference = 'Stop'

$packageName = $env:chocolateyPackageName
$installDir = Split-Path $MyInvocation.MyCommand.Definition

Write-Host "$packageName is going to be installed in: $installDir"

$packageArgs = @{
  packageName     = $packageName
  url             = 'https://sourceforge.net/projects/ucon64/files/ucon64/ucon64-2.2.2/ucon64-2.2.2-win32-vc-bin.zip/download'
  checksum        = '4a4f3e6f46bb61a10db9e1764aa499de23879195aec626aaaed8379aeae3d6f8'
  checksumType    = 'sha256'
  unzipLocation   = $installDir
}

Install-ChocolateyZipPackage @packageArgs

