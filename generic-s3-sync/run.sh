#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Generic S3 Sync
# ==============================================================================
#bashio::log.level "debug"

function abspath() {
    # generate absolute path from relative path
    # $1     : relative filename
    # return : absolute path
    if [ -d "$1" ]; then
        # dir
        (cd "$1"; pwd)
    elif [ -f "$1" ]; then
        # file
        if [[ $1 = /* ]]; then
            echo "$1"
        elif [[ $1 == */* ]]; then
            echo "$(cd "${1%/*}"; pwd)/${1##*/}"
        else
            echo "$(pwd)/$1"
        fi
    fi
}

bashio::log.debug "Using AWS CLI version: '$(aws --version)'"
bashio::log.info "Starting Generic S3 Sync..."

sync_paths="$(bashio::config 'sync_paths')"
bucket_name="$(bashio::config 'bucket_name')"
bucket_region="$(bashio::config 'bucket_region')"
endpoint_url="$(bashio::config 'endpoint_url')"

export AWS_ACCESS_KEY_ID="$(bashio::config 's3_access_key')"
export AWS_SECRET_ACCESS_KEY="$(bashio::config 's3_secret_access_key')"

for local_path in $sync_paths; do
  bashio::log.info "Syncing path '$local_path' ..."
  remote_path="s3://$bucket_name$(abspath "$local_path")"
  aws s3 sync "$local_path" "$remote_path" \
    --delete \
    --no-progress \
    --region "$bucket_region" \
    --endpoint-url "$endpoint_url"
done

bashio::log.info "Finished Generic S3 Sync."
