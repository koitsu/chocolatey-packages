# script based on tunisiano187, released under AGPL-3.0 License
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
$typName = 'HIBPOfflineCheck.plgx'
$url = 'https://github.com/mihaifm/HIBPOfflineCheck/releases/download/1.7.8/HIBPOfflineCheck.plgx'
$checksum = 'a699fbe6c6fec5726c1ffaf26b87073dc89bf3065f734080d0a80d03038db9dc'
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
