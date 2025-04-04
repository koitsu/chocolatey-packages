$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$packageArgs = @{
  packageName  = $env:ChocolateyPackageName
  fileFullPath = "$toolsDir\asm6f_v03_20250127.zip"
  destination  = $toolsDir
}

Get-ChocolateyUnzip @packageArgs

if ((Get-OSArchitectureWidth 64) -and $env:chocolateyForceX86 -ne 'true') {
  Write-Host "x64 architecture detected, using asm6f_64.exe exclusively"
  Remove-Item "$toolsDir\asm6f_32.exe"
  Rename-Item "$toolsDir\asm6f_64.exe" "asm6f.exe"
} else {
  Write-Host "x86 architecture detected, using asm6f_32.exe exclusively"
  Remove-Item "$toolsDir\asm6f_64.exe"
  Rename-Item "$toolsDir\asm6f_32.exe" "asm6f.exe"
}
