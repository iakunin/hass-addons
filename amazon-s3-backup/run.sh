#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Amazon S3 Backup
# ==============================================================================
#bashio::log.level "debug"

bashio::log.info "Starting Amazon S3 Backup..."

bucket_name="$(bashio::config 'bucket_name')"
bucket_region="$(bashio::config 'bucket_region')"
monitor_path="$(bashio::config 'monitor_path')"

export AWS_ACCESS_KEY_ID="$(bashio::config 'aws_access_key')"
export AWS_SECRET_ACCESS_KEY="$(bashio::config 'aws_secret_access_key')"
export AWS_REGION="$bucket_region"

bashio::log.debug "Using AWS CLI version: '$(aws --version)'"
bashio::log.debug "Command: 'aws s3 sync $monitor_path s3://$bucket_name/ --no-progress --region $bucket_region'"
aws s3 sync $monitor_path s3://"$bucket_name"/ --no-progress --region "$bucket_region"

bashio::log.info "Finished Amazon S3 Backup."
