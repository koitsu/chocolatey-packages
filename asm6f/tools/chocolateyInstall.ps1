# Based on sources:
# https://github.com/chocolatey-community/chocolatey-packages/blob/master/automatic/sysinternals/tools/chocolateyInstall.ps1
# https://github.com/chocolatey-community/chocolatey-packages/blob/master/automatic/curl/tools/chocolateyInstall.ps1
# https://github.com/chocolatey-community/chocolatey-packages/blob/master/automatic/wget/tools/chocolateyinstall.ps1

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
$pp = Get-PackageParameters
$installDir = $toolsPath

if ($pp.InstallDir -or $pp.InstallationPath) {
  $InstallDir = $pp.InstallDir + $pp.InstallationPath
}

Write-Host "asm6f is going to be installed in '$installDir'"

$packageArgs = @{
  packageName     = $env:chocolateyPackageName
  url             = 'https://github.com/freem/asm6f/releases/download/v1.6_freem02/asm6f_20181019.zip'
  checksum        = 'd5ab4445f4624e801748ac2b3cab4d6560721a1c302456c44d53d1e353c92ef3'
  checksumType    = 'sha256'
  unzipLocation   = $installDir
}

Install-ChocolateyZipPackage @packageArgs

if ((Get-OSArchitectureWidth 64) -and $env:chocolateyForceX86 -ne 'true') {
  Write-Host "x64 architecture detected, using asm6f_64.exe exclusively"
  Remove-Item "$installDir\asm6f_32.exe"
  Rename-Item "$installDir\asm6f_64.exe" "asm6f.exe"
} else {
  Write-Host "x86 architecture detected, using asm6f_32.exe exclusively"
  Remove-Item "$installDir\asm6f_64.exe"
  Rename-Item "$installDir\asm6f_32.exe" "asm6f.exe"
}
