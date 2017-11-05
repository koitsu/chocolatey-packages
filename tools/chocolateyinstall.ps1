$ErrorActionPreference = 'Stop';

$packageName = 'HxD'
$url32       = 'https://mh-nexus.de/downloads/HxDSetup.zip'
$checksum32  = ''

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$zipLocation = Join-Path $toolsDir 'HxDSetup.zip'
$setupLocation = Join-Path $toolsDir 'HxDSetup.exe'

$webArgs = @{
	packageName  = $packageName
	fileFullPath = $zipLocation
	url          = $url32
	checksum     = $checksum32
	checksumType = 'sha256'
}

Get-ChocolateyWebFile @webArgs
Get-ChocolateyUnzip $zipLocation $toolsDir
Install-ChocolateyPackage $packageName 'exe' '/silent' $setupLocation

Remove-Item $zipLocation
Remove-Item $setupLocation
