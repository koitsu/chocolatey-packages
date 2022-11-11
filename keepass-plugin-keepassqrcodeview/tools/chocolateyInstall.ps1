﻿# script based on tunisiano187, released under AGPL-3.0 License
# source: https://github.com/tunisiano187/Chocolatey-packages/blob/master/automatic/keepass-plugin-kpscript/tools/chocolateyInstall.ps1

# powershell v2 compatibility
$psVer = $PSVersionTable.PSVersion.Major
if ($psver -ge 3) {
  function Get-ChildItemDir {Get-ChildItem -Directory $args}
} else {
  function Get-ChildItemDir {Get-ChildItem $args}
}
$packageName = $env:ChocolateyPackageName
$packageSearch = 'KeePass Password Safe'
$typName = 'KeePassQRCodeView.plgx'
$url = 'https://github.com/JanisEst/KeePassQRCodeView/releases/download/v1.1.0/KeePassQRCodeView.plgx'
$checksum = '5589badfb30281e3bbe6a0046c95f0d6fd2efe6c2a4d0e117d78985bca12b651'
$checksumType = 'sha256'
try {
# search registry for location of installed KeePass
$regPath = Get-ItemProperty -Path @('HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*') `
                            -ErrorAction:SilentlyContinue `
           | Where-Object {$_.DisplayName -like "$packageSearch*" `
                           -and `
                           $_.DisplayVersion -ge 2.42 `
                           -and `
                           $_.DisplayVersion -lt 3.0 } `
           | ForEach-Object {$_.InstallLocation}
$installPath = $regPath + "Plugins\"
if (! $installPath) {
  Write-Verbose "$($packageSearch) not found installed."
  $binRoot = Get-BinRoot
  $portPath = Join-Path $binRoot "keepass"
  $installPath = Get-ChildItemDir $portPath* -ErrorAction SilentlyContinue
}
if (! $installPath) {
  throw "$($packageSearch) location could not be found."
}
$pluginPath = $installPath
$installFile = Join-Path $pluginPath $typName
# download PLGX file into Plugins dir
Get-ChocolateyWebFile -PackageName "$packageName" `
                             -Url "$url" `
                             -FileFullPath  "$installFile" `
                             -Checksum "$checksum" `
                             -ChecksumType "$checksumType"
if ( Get-Process -Name "KeePass" `
                 -ErrorAction SilentlyContinue ) {
  Write-Warning "$($packageSearch) is currently running. Plugin will be available at next restart of $($packageSearch)."
} else {
  Write-Output "$($packageName) will be loaded the next time KeePass is started."
  Write-Output "Please note this plugin may require additional configuration. Look for a new entry in KeePass' Menu -> Tools"
}} catch {
  throw $_.Exception
}