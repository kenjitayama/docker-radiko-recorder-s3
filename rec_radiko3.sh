#!/bin/sh

set -eu

USERNAME='Radiko Recorder'
mkdir -p /var/radiko

curl -X POST --data-urlencode "payload={\"channel\": \"#${SLACK_CHANNEL}\", \"username\": \"${USERNAME}\", \"text\": \"Started recording ${STATION} for ${DURATION_MINUTES} minutes\"}" $SLACK_WEBHOOK_URL

/usr/local/bin/rec_radiko2.sh $STATION $DURATION_MINUTES $RADIKO_LOGIN $RADIKO_PASSWORD /var/radiko

for F in $(ls /var/radiko/*.mp3); do
  echo "Uploading ${F}"
  FNAME=$(basename $F)
  aws s3 cp --acl public-read $F "s3://${S3_BUCKET}/${FNAME}"
  URL="https://${S3_BUCKET}.s3.amazonaws.com/${FNAME}"
  curl -X POST --data-urlencode "payload={\"channel\": \"#${SLACK_CHANNEL}\", \"username\": \"${USERNAME}\", \"text\": \"Completed recording ${STATION} for ${DURATION_MINUTES} minutes\",\"attachments\":[{\"title\":\"${FNAME}\",\"title_link\":\"${URL}\"}]}" $SLACK_WEBHOOK_URL
done
