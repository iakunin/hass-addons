# Home Assistant Add-on: Generic S3 Sync

## Installation

Follow these steps to get the add-on installed on your system:

1. Enable **Advanced Mode** in your Home Assistant user profile.
2. Navigate in your Home Assistant frontend to **Supervisor** -> **Add-on Store**.
3. Search for "Generic S3 Sync" add-on and click on it.
4. Click on the "INSTALL" button.

## How to use

1. Set all the required config properties. 
2. Start the add-on to sync your `sync_paths` directories to the configured `bucket_name` on Generic S3. You can also automate this of course, see example below:

## Automation

To automate syncing to S3, add this automation in Home Assistants `configuration.yaml` and change it to your needs:
```
automation:
  - id: sync_to_s3
    alias: Sync to S3 every day at 4am
    trigger:
      platform: time
      at: "04:00:00"
    action:
      service: hassio.addon_start
      data:
        addon: XXXXX_generic-s3-sync
```

The automation above runs generic-s3-sync every day at 4am.

## Configuration

Example add-on configuration:

```
sync_paths: 
  - /backup
  - /media/my-nas
s3_access_key: AKXXXXXXXXXXXXXXXX
s3_secret_access_key: XXXXXXXXXXXXXXXX
bucket_name: my-bucket
bucket_region: ru-central1
endpoint_url: https://storage.yandexcloud.net
```

### Option: `sync_paths` (required)
Source paths (one or multiple) to sync.

### Option: `s3_access_key` (required)
IAM access key used to access the S3 bucket.

### Option: `s3_secret_access_key` (required)
IAM secret access key used to access the S3 bucket.

### Option: `bucket_name` (required)
S3 bucket used to store.

### Option: `bucket_region` (required)
Region where the S3 bucket was created. See https://aws.amazon.com/about-aws/global-infrastructure/ for all available regions.

### Option: `endpoint_url` (required)
S3 endpoint url.

## Security
I recommend to create a new IAM user, which:
- can not login to the AWS Console
- can only access AWS programmatically
- is used by this add-on only
- uses the lowest possible IAM Policy, which is this:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowAWSS3Sync",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::YOUR-S3-BUCKET-NAME/*",
                "arn:aws:s3:::YOUR-S3-BUCKET-NAME"
            ]
        }
    ]
}
```

## Support
Usage of the addon requires knowledge of Amazon S3 and AWS IAM.
Under the hood it uses the aws cli version 1, specifically the `aws s3 sync` command.

## Thanks
This addon is highly inspired by:
- https://github.com/gdrapp/hass-addons
- https://github.com/rrostt/hassio-backup-s3
- https://github.com/thomasfr/hass-addons
