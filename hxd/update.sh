#!/usr/bin/env bash
set -e
shopt -s expand_aliases

t1=$(mktemp)
curl -s -S -o "${t1}" 'https://mh-nexus.de/updates/HxDCurrentVersion.json'
version=$(cat "${t1}" | jq -r '.Version')
zipurl=$(cat "${t1}" | jq -r '."Download-URI"')
jsonchecksum=$(cat "${t1}" | jq -r '."Unique-File-IDs"."SHA-512"' | tr 'A-F' 'a-f')

# Version 2.5.0.0 testing
# curl -s -S -o "${t1}" 'https://mh-nexus.de/HxD2.5.0.0-installable-BCP47-Language-Tags.json'
# version=$(cat "${t1}" | jq -r '.Version')
# zipurl=$(cat "${t1}" | jq -r '."Download-URI"."*"')
# jsonchecksum=$(cat "${t1}" | jq -r '."Unique-File-IDs"."HxDSetup.zip"."SHA-512"' | tr 'A-F' 'a-f')

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

# Ensure the checksum specified by the HxD author (in the JSON manifest)
# matches what we got when downloading the .zip file ourselves.
# If these don't match, then bail out with an error and DO NOT update
# the Chocolatey package.
# Ideally this should never happen, barring corrupt network traffic, MITM
# attacks, local filesystem corruption, or (possibly) HxD maintainer
# forgetting to update the checksum in the JSON but updating the .zip
# file itself.

if [[ "${checksum}" != "${jsonchecksum}" ]]; then
  echo "ERROR: JSON manifest checksum does not match local .zip checksum!"
  echo "JSON manifest: $jsonchecksum"
  echo "Local:         $checksum"
  exit 1
fi

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
