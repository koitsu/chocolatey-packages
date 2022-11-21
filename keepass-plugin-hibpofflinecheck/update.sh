#!/usr/bin/env bash
set -e
set -x

# https://docs.github.com/en/rest/releases/releases#get-the-latest-release

t1=$(mktemp)
curl -s -S \
  -o "${t1}" \
  -A 'koitsu' \
  -H 'Accept: application/vnd.github+json' \
  'https://api.github.com/repos/mihaifm/HIBPOfflineCheck/releases/latest'

plgxurl=$(cat "${t1}" | jq -r '.assets[] | select(.name | endswith(".plgx")) | .browser_download_url')
version=$(cat "${t1}" | jq -r '.tag_name')

# XXX debug
# cat ${t1} | jq .

rm -f "${t1}"

case "$(uname -s)" in
  Linux)   checksum=$(curl -s -L -o- "${plgxurl}" | sha256sum | awk '{ print $1 }') ;;
  FreeBSD) checksum=$(curl -s -L -o- "${plgxurl}" | sha256) ;;
  *)       echo "ERROR: Unknown platform for sha256 checksum utility" ; exit 1
esac

echo "Latest release details:"
echo "version:  $version"
echo "plgxurl:  $plgxurl"
echo "checksum: $checksum"
echo

license_url="https://github.com/mihaifm/HIBPOfflineCheck/blob/${version}/LICENSE"
docs_url="https://github.com/mihaifm/HIBPOfflineCheck/blob/${version}/readme.md"

nuspec="keepass-plugin-hibpofflinecheck.nuspec"
install_ps1="tools/chocolateyInstall.ps1"

# Update nuspec with new licenseUrl, docsUrl, and version parameters

perl -p -i \
  -e "s|>.+<|>${license_url}<| if m|<licenseUrl>|;" \
  -e "s|>.+<|>${docs_url}<|    if m|<docsUrl>|;" \
  -e "s|>.+<|>${version}<|     if m|<version>|;" \
  "${nuspec}"

# Update chocolateyInstall.ps1 with new url64bit and checksum64

perl -p -i \
  -e "s|'.+'|'${plgxurl}'|  if m|\\\$url\s*=|;" \
  -e "s|'.+'|'${checksum}'| if m|\\\$checksum\s*=|;" \
  "${install_ps1}"

git status
git --no-pager diff
