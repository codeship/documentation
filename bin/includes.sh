#!/bin/zsh
set -e

# switch to the toor of the directory
DIR="$(cd "$(dirname "${0}")/../" && pwd)"
cd "${DIR}"

# helper functions
function log() { echo -e "\e[36m$@\e[39m"; }

# cleanup at the end of the script
function on_exit() {
	local exit_code=$?
	rm -rf '.tmp'
	exit ${exit_code}
}
trap on_exit EXIT

rm -rf '.tmp' && mkdir -p '.tmp'
jq -cr '.[]' _includes.json | while read key; do
	url=$(echo "${key}" | jq -r '.repository')
	name=$(echo "${key}" | jq -r '.repository | @sh')
	branch=$(echo "${key}" | jq -r '.branch // "master"')
	source_folder=$(echo "${key}" | jq -r '.source')
	dest_folder=$(echo "${key}" | jq -r '.destination')

	log "Copying ${source_folder} from repository ${url} (branch ${branch}) to ${dest_folder}"
	if [ ! -d ".tmp/${name}" ]; then
		git clone --branch "${branch}" --single-branch --depth "1" "${url}" ".tmp/${name}"
	fi
	cd ".tmp/${name}"
	cp -r "./${source_folder}" "${DIR}/${dest_folder}"
	cd -
done
