<#
	This generates hashes.json which is read by chocolateyInstall.ps1.
	
	I am unsure whether the effort of hashing all files is worth being integrated at each AU run
	(one could probably only do the hasing once the version changes).
	It is therefore currently required to run this file every time the version changes.
	The last version change was 2009, so I don't expect much work of manual updating :)	
#>

$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

. "$scriptPath\tools\languages.ps1"

$availableLanguages = Get-AvailableLanguages

$document = $availableLanguages.Keys | % {
	$actualLangCode = $availableLanguages.Get_Item($_)
	$uri = "https://mh-nexus.de/downloads/HxDSetup${actualLangCode}.zip" 

	$tempFile = [System.IO.Path]::GetTempFileName()
	Invoke-WebRequest -Uri $uri -OutFile $tempFile -UserAgent "Update checker of Chocolatey Community Package 'HxD'"
	
	$entry = @{lang = $_; uri = $uri; hash = (Get-FileHash $tempFile -Algorithm 'SHA256').Hash}
	Remove-Item $tempFile

	$entry
} | ConvertTo-Json

[IO.File]::WriteAllLines("$scriptPath\tools\hashes.json", $document)
