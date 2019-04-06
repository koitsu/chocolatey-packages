$ErrorActionPreference = 'Stop';

$checksum32 = 'DFA79BB97CF4B80D73E73DBCE83EAE1217B3FD8138D0B052D886A1FCC9051B37EB624E2F9E0C47830092F005944F88437240631AD2FBDDE29B0051814740812D'

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$zipLocation   = Join-Path $toolsDir 'HxDSetup.zip'
$unzipLocation = Join-Path $toolsDir 'HxDSetup'
$setupLocation = Join-Path $unzipLocation 'HxDSetup.exe'

Get-ChecksumValid -File $zipLocation -Checksum $checksum32 -ChecksumType 'sha512'

Get-ChocolateyUnzip $zipLocation $unzipLocation
Install-ChocolateyInstallPackage 'HxD' 'exe' '/silent' $setupLocation

Remove-Item $unzipLocation -Recurse
