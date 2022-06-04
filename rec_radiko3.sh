#!/bin/sh

urlencode() {
  echo "$1" | nkf -WwMQ | sed 's/=$//g' | tr = % | tr -d '\n'
}

set -eu

USERNAME='Radiko Recorder'
DIR=/var/radiko
TIME=$(date +"%Y-%m-%d-%H_%M")
URLENCODED_PROGRAM_NAME=`urlencode "${PROGRAM_NAME}"`
FNAME="${PROGRAM_NAME}_${STATION}_${TIME}.m4a"
URLENCODED_FNAME="${URLENCODED_PROGRAM_NAME}_${STATION}_${TIME}.m4a"
OUTFILE="${DIR}/${URLENCODED_FNAME}"
mkdir -p $DIR

if [ -n "$SLACK_WEBHOOK_URL" ]; then
  curl -s -X POST --data-urlencode "payload={\"channel\": \"#${SLACK_CHANNEL}\", \"username\": \"${USERNAME}\", \"text\": \"Started recording ${STATION} for ${DURATION_MINUTES} minutes\"}" $SLACK_WEBHOOK_URL
fi

if [ -n "$RADIKO_LOGIN" ]; then
  /usr/local/bin/radi.sh \
    -t radiko \
    -s $STATION \
    -d $DURATION_MINUTES \
    -i $RADIKO_LOGIN \
    -p $RADIKO_PASSWORD \
    -o $OUTFILE
else
  /usr/local/bin/radi.sh \
    -t radiko \
    -s $STATION \
    -d $DURATION_MINUTES \
    -o $OUTFILE
fi

echo "Uploading \"$FNAME\""
aws s3 cp --acl public-read "$OUTFILE" "s3://${S3_BUCKET}/${URLENCODED_FNAME}"
URL="https://${S3_BUCKET}.s3.amazonaws.com/${URLENCODED_FNAME}"


if [ -n "$SLACK_WEBHOOK_URL" ]; then
  curl -s -X POST --data-urlencode "payload={\"channel\": \"#${SLACK_CHANNEL}\", \"username\": \"${USERNAME}\", \"text\": \"Completed recording ${STATION} for ${DURATION_MINUTES} minutes\",\"attachments\":[{\"title\":\"${URLENCODED_FNAME}\",\"title_link\":\"${URL}\"}]}" $SLACK_WEBHOOK_URL
fi

