#!/usr/bin/env bash
set -e
shopt -s expand_aliases

# https://docs.github.com/en/rest/releases/releases#get-the-latest-release

t1=$(mktemp)
curl -s -S \
  -o "${t1}" \
  -A 'koitsu' \
  -H 'Accept: application/vnd.github+json' \
  'https://api.github.com/repos/cortesi/devd/releases/latest'

zipurl32=$(cat "${t1}" | jq -r '.assets[] | select(.name | endswith("-windows32.zip")) | .browser_download_url')
zipurl64=$(cat "${t1}" | jq -r '.assets[] | select(.name | endswith("-windows64.zip")) | .browser_download_url')
version_str=$(cat "${t1}" | jq -r '.tag_name')
version_num=${version_str/v/}

# XXX debug
# cat ${t1} | jq .

rm -f "${t1}"

case "$(uname -s)" in
  Linux|CYGWIN*|MINGW*)
    alias sed="sed -i"
    checksum32=$(curl -s -L -o- "${zipurl32}" | sha256sum | awk '{ print $1 }')
    checksum64=$(curl -s -L -o- "${zipurl64}" | sha256sum | awk '{ print $1 }')
    ;;
  FreeBSD)
    alias sed="sed -i ''"
    checksum32=$(curl -s -L -o- "${zipurl32}" | sha256)
    checksum64=$(curl -s -L -o- "${zipurl64}" | sha256)
    ;;
  *) echo "ERROR: Unknown platform for sha256 checksum utility" ; exit 1
esac

echo "Latest release details:"
echo "version_str: $version_str"
echo "version_num: $version_num"
echo "zipurl32:    $zipurl32"
echo "checksum32:  $checksum32"
echo "zipurl64:    $zipurl64"
echo "checksum64:  $checksum64"
echo

license_url="https://github.com/cortesi/devd/blob/${version_str}/LICENSE"
docs_url="https://github.com/cortesi/devd/blob/${version_str}/README.md"

nuspec="devd.nuspec"
install_ps1="tools/chocolateyInstall.ps1"

# Update nuspec with new licenseUrl, docsUrl, and version parameters

sed -r \
  -e "/<licenseUrl>/ s|>.+<|>${license_url}<|" \
  -e "/<docsUrl>/    s|>.+<|>${docs_url}<|" \
  -e "/<version>/    s|>.+<|>${version_num}<|" \
  "${nuspec}"

# Update chocolateyInstall.ps1 with new url64bit and checksum64

sed -r \
  -e "/url[[:space:]]*=/        s|'.+'|'${zipurl32}'|" \
  -e "/url64bit[[:space:]]*=/   s|'.+'|'${zipurl64}'|" \
  -e "/checksum[[:space:]]*=/   s|'.+'|'${checksum32}'|" \
  -e "/checksum64[[:space:]]*=/ s|'.+'|'${checksum64}'|" \
  "${install_ps1}"

git status
git --no-pager diff
