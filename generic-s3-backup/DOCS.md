# Home Assistant Add-on: Generic S3 Backup

## Installation

Follow these steps to get the add-on installed on your system:

1. Enable **Advanced Mode** in your Home Assistant user profile.
2. Navigate in your Home Assistant frontend to **Supervisor** -> **Add-on Store**.
3. Search for "Generic S3 Backup" add-on and click on it.
4. Click on the "INSTALL" button.

## How to use

1. Set all the required config properties. 
2. Start the add-on to sync your `backup_path` directory to the configured `bucket_name` on Generic S3. You can also automate this of course, see example below:

## Automation

To automate your backup creation and syncing to S3, add these two automations in Home Assistants `configuration.yaml` and change it to your needs:
```
automation:
  # create a full backup
  - id: backup_create_full_backup
    alias: Create a full backup every day at 4am
    trigger:
      platform: time
      at: "04:00:00"
    action:
      service: hassio.backup_full
      data:
        # uses the 'now' object of the trigger to create a more user friendly name (e.g.: '202101010400_automated-backup')
        name: "{{as_timestamp(trigger.now)|timestamp_custom('%Y%m%d%H%M', true)}}_automated-backup"

  # Starts the addon 15 minutes after every hour to make sure it syncs all backups, also manual ones, as soon as possible
  - id: backup_upload_to_s3
    alias: Upload to S3
    trigger:
      platform: time_pattern
      # Matches every hour at 15 minutes past every hour
      minutes: 15
    action:
      service: hassio.addon_start
      data:
      addon: XXXXX_amazon-s3-backup
```

The automation above first creates a full backup at 4am, and then at 4:15am syncs to Amazon S3 and if configured deletes local backups according to your configuration.

## Configuration

Example add-on configuration:

```
backup_paths: 
  - /backup
  - /media/my-nas
s3_access_key: AKXXXXXXXXXXXXXXXX
s3_secret_access_key: XXXXXXXXXXXXXXXX
bucket_name: my-bucket
bucket_region: ru-central1
endpoint_url: https://storage.yandexcloud.net
```

### Option: `backup_paths` (required)
Source paths (one or multiple) to make backup.

### Option: `s3_access_key` (required)
IAM access key used to access the S3 bucket.

### Option: `s3_secret_access_key` (required)
IAM secret access key used to access the S3 bucket.

### Option: `bucket_name` (required)
S3 bucket used to store backups.

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
