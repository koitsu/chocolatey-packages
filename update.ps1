Import-Module au

function global:au_BeforeUpdate() {
	$embeddedBinaryPath = [IO.Path]::combine($PSScriptRoot, 'tools', 'HxDSetup.zip')

	Remove-Item $embeddedBinaryPath
	Invoke-WebRequest -Uri 'ftp://wa651f1:anonymous@mh-nexus.de/HxDSetup.zip' -OutFile $embeddedBinaryPath | Out-Null
}

function global:au_AfterUpdate ($Package)  {
	Set-DescriptionFromReadme $Package
}

function global:au_SearchReplace {
	@{
		'hxd.nuspec' = @{
			'<version>[^<]*</version>' = "<version>$($Latest.Version)</version>"
		}
	}
}

function global:au_GetLatest {
	$uri = 'https://mh-nexus.de/en/hxd/changelog.php'
	$page = Invoke-WebRequest -Uri $uri -UserAgent "Update checker of Chocolatey Community Package 'HxD'"

	$version = Get-FixedQuerySelectorAll $page 'table tr td:first-child' | Select -First 1 -ExpandProperty innerText

	# Download binary manually in global:au_BeforeUpdate() because specfying the URL
	# here and reyling on AU would trigger a bug: https://github.com/majkinetor/au/issues/161
	return @{ Version = $version }
}

# Function taken from http://stackoverflow.com/a/37663738 under CC BY-SA 3.0
# Many thanks to author midnightfreddie: http://stackoverflow.com/users/4844551/midnightfreddie
function Get-FixedQuerySelectorAll {
	param (
		$HtmlWro,
		$CssSelector
	)
	# After assignment, $NodeList will crash powershell if enumerated in any way including Intellisense-completion while coding!
	$NodeList = $HtmlWro.ParsedHtml.querySelectorAll($CssSelector)

	for ($i = 0; $i -lt $NodeList.length; $i++) {
		Write-Output $NodeList.item($i)
	}
}


Update-Package -ChecksumFor None
