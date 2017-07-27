#!/bin/sh
set -e
log() { echo -e "\033[36m$@\033[39m"; }
action=${1:?'You need to pass an action!'} && shift

case "$action" in
	'sync')
		if [ "${CI_BRANCH}" = "master" ]; then
			log "Pushing documenation to s3://${AWS_S3_BUCKET}/"
			aws s3 sync "/site/master/" "s3://${AWS_S3_BUCKET}/" --acl public-read --cache-control "${AWS_CACHE_CONTROL}" --follow-symlinks --exclude "staging/*" --exclude "private/*" --delete
		else
			target="${CI_BRANCH}"
			log "Pushing documenation to s3://${AWS_S3_BUCKET}/${target}/"
			aws s3 sync "/site/${target}/" "s3://${AWS_S3_BUCKET}/${target}/" --acl public-read --cache-control "private, no-cache" --follow-symlinks --delete
		fi
		;;
	'configure_website')
		log "Pushing website configuration"
		config_file=${1:?'You need to pass an action!'} && shift
		aws s3api put-bucket-website --bucket "${AWS_S3_BUCKET}" --website-configuration "file://${config_file}"
		;;
	'configure_lifecycle')
		log "Pushing lifecycle configuration"
		config_file=${1:?'You need to pass an action!'} && shift
		aws s3api put-bucket-lifecycle --bucket "${AWS_S3_BUCKET}" --lifecycle-configuration "file://${config_file}"
		;;
	'configure_redirects')
		if [ "${CI_BRANCH}" = "master" ]; then
			cd /site/master/ || exit 1
		else
			cd /site/ || exit 1
		fi
		for file in $(grep -rl -E '<meta\s+http-equiv="refresh"\s+content="0;\s+url=.*">' *); do
			src="${file}"
			tgt=$(grep -o -E '<meta\s+http-equiv="refresh"\s+content="0;\s+url=.*">' "${file}" | sed -E 's/<meta http-equiv="refresh" content="0; url=(.*)">/\1/g')
			log "Redirect ${src} to ${tgt}"
			aws s3api put-object \
			  --bucket "${AWS_S3_BUCKET}" \
			  --key "${src}" \
			  --website-redirect-location "${tgt}" \
			  --acl "public-read" \
			  --content-type "text/html" \
			  --body "${file}"
		done
		cd - || exit 1
		;;
	*)
		log "Invalid action ${action} :("
		exit 1
		;;
esac
