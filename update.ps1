Import-Module au

function global:au_BeforeUpdate() {
    Get-RemoteFiles -Purge -NoSuffix -Algorithm 'sha512'
}

function global:au_AfterUpdate ($Package)  {
	Set-DescriptionFromReadme $Package
}

function global:au_SearchReplace {
	@{
		'hxd.nuspec' = @{
			'<version>[^<]*</version>' = "<version>$($Latest.Version)</version>"
		};
		'.\tools\VERIFICATION.txt' = @{
			'(^.*)(tools/HxDSetup.zip SHA-512: )([a-zA-Z0-9]+)(.*$)' = '${1}${2}' + $Latest.Checksum32 + '${4}'
		};
		'tools\chocolateyInstall.ps1' = @{
			"(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
		}
	}
}

function global:au_GetLatest {
	$uri = 'https://mh-nexus.de/updates/HxDCurrentVersion.json'
	$latestData = Invoke-WebRequest -Uri $uri -UserAgent "Update checker of Chocolatey Community Package 'HxD'" | ConvertFrom-Json

	# The checksum will be computed by Get-RemoteFiles in au_BeforeUpdate().
	return @{
		URL32 = $latestData.'Download-URI';
		Version = $latestData.'Version';
	}
}

Update-Package -ChecksumFor None
