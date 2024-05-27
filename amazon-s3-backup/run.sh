#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Amazon S3 Backup
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

bashio::log.info "Starting Amazon S3 Backup..."

backup_path="$(bashio::config 'backup_path')"
bucket_name="$(bashio::config 'bucket_name')"
bucket_region="$(bashio::config 'bucket_region')"
endpoint_url="$(bashio::config 'endpoint_url')"
remote_path="s3://$bucket_name$(abspath "$backup_path")"

export AWS_ACCESS_KEY_ID="$(bashio::config 'aws_access_key')"
export AWS_SECRET_ACCESS_KEY="$(bashio::config 'aws_secret_access_key')"
#export AWS_REGION="$bucket_region"


bashio::log.debug "Using AWS CLI version: '$(aws --version)'"
#bashio::log.debug "Command: 'aws s3 sync $backup_path s3://$bucket_name/ --no-progress --region $bucket_region --endpoint-url $endpoint_url'"
set -x
aws s3 sync "$backup_path" "$remote_path" \
  --delete \
  --region "$bucket_region" \
  --endpoint-url "$endpoint_url"

bashio::log.info "Finished Amazon S3 Backup."
