FROM atsnngs/radish:latest
MAINTAINER Atsushi Nagase<a@ngs.io>

RUN apt-get update -y && apt-get install -y python-pip curl nkf
RUN pip install awscli
ADD rec_radiko3.sh /usr/local/bin/rec_radiko3.sh

ENTRYPOINT /usr/local/bin/rec_radiko3.sh
