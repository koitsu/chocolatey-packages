#!/usr/bin/env bash
set -e
shopt -s expand_aliases

t1=$(mktemp)
curl -s -S -o "${t1}" 'https://mh-nexus.de/updates/HxDCurrentVersion.json'
version=$(cat "${t1}" | jq -r '.Version')
zipurl=$(cat "${t1}" | jq -r '."Download-URI"')

# Version 2.5.0.0 testing
# curl -s -S -o "${t1}" 'https://mh-nexus.de/HxD2.5.0.0-installable-BCP47-Language-Tags.json'
# version=$(cat "${t1}" | jq -r '.Version')
# zipurl=$(cat "${t1}" | jq -r '."Download-URI"."*"')

# XXX debug
# cat ${t1} | jq .

rm -f "${t1}"

case "$(uname -s)" in
  Linux|CYGWIN*|MINGW*)
    alias sed="sed -i"
    checksum=$(curl -s -L -o- "${zipurl}" | sha512sum | awk '{ print $1 }')
    ;;
  FreeBSD)
    alias sed="sed -i ''"
    checksum=$(curl -s -L -o- "${zipurl}" | sha512)
    ;;
  *) echo "ERROR: Unknown platform for sha512 checksum utility" ; exit 1
esac

echo "Latest release details:"
echo "version:  $version"
echo "zipurl:   $zipurl"
echo "checksum: $checksum"
echo

nuspec="hxd.nuspec"
install_ps1="tools/chocolateyInstall.ps1"

# Update nuspec with new version parameter

sed -r \
  -e "/<version>/ s|>.+<|>${version}<|" \
  "${nuspec}"

# Update chocolateyInstall.ps1 with new url and checksum

sed -r \
  -e "/url[[:space:]]*=/        s|'.+'|'${zipurl}'|" \
  -e "/checksum[[:space:]]*=/   s|'.+'|'${checksum}'|" \
  "${install_ps1}"

git status
git --no-pager diff
