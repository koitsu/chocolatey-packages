$ErrorActionPreference = 'Stop'

if ($env:chocolateyForceX86 -eq 'true') {
  $err = ("This package does not support --x86/--force86. The installer" +
  " chooses which to install depending on OS architecture. It cannot be" +
  " overridden using this flag.")
  Write-Error $err
}

$packageName = $env:ChocolateyPackageName
$toolsDir    = Split-Path -Parent $MyInvocation.MyCommand.Definition

$zipFilePath  = Join-Path $toolsDir 'HxDSetup.zip'
$setupExePath = Join-Path $toolsDir 'HxDSetup.exe'

$packageArgs = @{
  packageName  = $packageName
  fileFullPath = $zipFilePath
  destination  = $toolsDir
}

Get-ChocolateyUnzip @packageArgs

$packageArgs = @{
  packageName    = $packageName
  fileType       = 'exe'
  file           = $setupExePath
  silentArgs     = '/VERYSILENT /NORESTART'
  validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

Remove-Item $setupExePath
