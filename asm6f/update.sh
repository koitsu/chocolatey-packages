#!/usr/bin/env bash
set -e

# https://docs.github.com/en/rest/releases/releases#get-the-latest-release

t1=$(mktemp)
curl -s -S \
  -o "${t1}" \
  -H 'Accept: application/vnd.github+json' \
  'https://api.github.com/repos/freem/asm6f/releases/latest'

zipurl=$(cat "${t1}" | jq -r '.assets[] | select(.name | contains(".zip")) | .browser_download_url')
tag_name=$(cat "${t1}" | jq -r '.tag_name')
version_str=$(echo "${tag_name}" | cut -d'_' -f1)
version_num=${version_str/v/}
build=$(basename "${zipurl}" | cut -d'_' -f2)
build=${build%%.zip}

# XXX debug
# cat ${t1} | jq .

rm -f "${t1}"

case "$(uname -s)" in
  Linux)   checksum=$(curl -s -L -o- "${zipurl}" | sha256sum | awk '{ print $1 }') ;;
  FreeBSD) checksum=$(curl -s -L -o- "${zipurl}" | sha256) ;;
  *)       echo "ERROR: Unknown platform for sha256 checksum utility" ; exit 1
esac

echo "Latest release details:"
echo "tag_name: $tag_name"
echo "version_str: $version_str"
echo "version_num: $version_num"
echo "zipurl:   $zipurl"
echo "build:    $build"
echo "checksum: $checksum"
echo

nuspec="asm6f.nuspec"
install_ps1="tools/chocolateyInstall.ps1"

# Update nuspec with new version parameters

perl -p -i \
  -e "s|>.+<|>${version_num}.${build}<| if m|<version>|;" \
  "${nuspec}"

# Update chocolateyInstall.ps1 with new url and checksum

perl -p -i \
  -e "s|'.+'|'${zipurl}'|   if m|url\s*=|;" \
  -e "s|'.+'|'${checksum}'| if m|checksum\s*=|;" \
  "${install_ps1}"

git status
git --no-pager diff
