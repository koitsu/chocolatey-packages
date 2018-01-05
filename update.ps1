Import-Module au

function global:au_AfterUpdate ($Package)  {
	Set-DescriptionFromReadme $Package
}

function global:au_SearchReplace {
	@{
		'hxd.nuspec' = @{
			"<version>[^<]*</version>" = "<version>$($Latest.Version)</version>"
		}
		'tools\chocolateyInstall.ps1' = @{
			"(^[$]url32\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
			"(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
		}
	}
}

function global:au_GetLatest {
	return @{ URL32 = "https://mh-nexus.de/downloads/HxDSetup.zip"; Version = "2.0-rc" }
}

Update-Package -ChecksumFor None
