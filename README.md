Radiko Recording Uploader
=========================

[![Docker Automated build](https://img.shields.io/docker/automated/atsnngs/radiko-recorder-s3.svg?maxAge=2592000)](https://hub.docker.com/r/atsnngs/radiko-recorder-s3/)

Environment Variables
---------------------

```sh
PROGRAM_NAME
STATION # http://www.dcc-jpl.com/foltia/wiki/radikomemo
DURATION_MINUTES
RADIKO_LOGIN # Optional. Must be premium member account.
RADIKO_PASSWORD
S3_BUCKET
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_DEFAULT_REGION
SLACK_WEBHOOK_URL
SLACK_CHANNEL
```

Run It
------

```sh
docker pull atsnngs/radiko-recorder-s3
docker run --env-file=.envrc atsnngs/radiko-recorder-s3
```

crontab
```sh
0 0 * * 2 docker run --rm -e PROGRAM_NAME=example_program_name -e STATION=ALPHA-STATION -e DURATION_MINUTES=60 --env-file /home/kenji/.radikorc kenjitayama/radiko-recorder-s3
```


