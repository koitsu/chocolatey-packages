$ErrorActionPreference = 'Stop';

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$zipLocation   = Join-Path $toolsDir 'HxDSetup.zip'
$unzipLocation = Join-Path $toolsDir "HxDSetup"
$setupLocation = Join-Path $unzipLocation 'HxDSetup.exe'

Get-ChocolateyUnzip $zipLocation $unzipLocation
Install-ChocolateyInstallPackage 'HxD' 'exe' '/silent' $setupLocation

Remove-Item $unzipLocation -Recurse
