#!/bin/bash
set -e
log() { echo -e "\033[36m$*\033[39m"; }
fail() { echo -e "\033[31m$*\033[39m"; exit 1; }

# Special settings for the "master" branch, compile the site to the "master"
# subdirectory, but use an empty baseurl, so we can deploy to the bucket root
target="${CI_BRANCH}"
baseurl="/${CI_BRANCH}"
JEKYLL_ENV="dev"
if [ "${CI_BRANCH}" = "master" ]; then
	baseurl=""
	JEKYLL_ENV="production"
elif [ "${CI_BRANCH}" = "${staging/*}" ] || [ "${CI_BRANCH}" = "${private/*}" ]; then
	JEKYLL_ENV="staging"
fi

# Where do we want to generate the site at?
destination="/site/$target"
if [ "${destination}" != "/site/" ]; then
	rm -rf "${destination}" && mkdir -p "${destination}"
fi

# Jet release notes and current version
jet_source="/site/.jet"
if [ -f "_data/jet.yml" ]; then
	sed -i'' -e "s|^version:.*|version: $(cat ${jet_source}/version)|" "_data/jet.yml"
fi
if [ -f "_pro/getting-started/release-notes.md" ]; then
	cat "${jet_source}/release-notes" >> "_pro/getting-started/release-notes.md"
fi
rm -rf "${jet_source}"

# Compile the site
log "Building with base URL '${baseurl}' and environment '${JEKYLL_ENV}'."
sed -i'' -e "s|^baseurl:.*|baseurl: ${baseurl}|" _config.yml
export JEKYLL_ENV
bundle exec jekyll build --destination "${destination}" 2>&1| tee build.log

# Fail if the build log from Jekyll contains any deprecations
deprecations=$(cat build.log | grep "Deprecation" -c)
if [ ${deprecations} -gt 0 ]; then
	fail "Found ${deprecations} deprecation warnings, please fix those first."
fi
