$ErrorActionPreference = 'Stop'

if ($env:chocolateyForceX86 -eq 'true') {
  $err = ("This package does not support --x86/--force86. The installer" +
  " chooses which to install depending on OS architecture. It cannot be" +
  " overridden using this flag.")
  Write-Error $err
}

$packageName = $env:chocolateyPackageName
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$unzipLocation = Join-Path $toolsDir 'HxDSetup'
$setupLocation = Join-Path $unzipLocation 'HxDSetup.exe'

$packageArgs = @{
  packageName     = $packageName
  url             = 'https://mh-nexus.de/downloads/HxDSetup.zip'
  checksum        = '33714bf909de383b2df6c7b860634cad0f1c0f6954753076c417feddc1477f506bc887b1b867a9ca2945fe90e6fd0ca70bbf74a63999a818e394d60cff59df99'
  checksumType    = 'sha512'
  unzipLocation   = $unzipLocation
}

Install-ChocolateyZipPackage @packageArgs

$packageArgs = @{
  packageName     = $packageName
  fileType        = 'exe'
  file            = $setupLocation
  silentArgs      = '/VERYSILENT /NORESTART'
  validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

Remove-Item $unzipLocation -Recurse
