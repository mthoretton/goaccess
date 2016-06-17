#!/bin/bash
#
# Required packages: awscli, goaccess (with btree and geoIP enable), zcat
#

set -eo pipefail

BUCKET_URL="s3://cf-logs.gyg.io"
DATE=`date +%y-%m-%d`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/"
# AWS will use Environment Variables (so they have to be exported before)

# List availables logfiles
logs_a=(`aws s3 ls "$BUCKET_URL" | awk '{print $4}'`)

for log in "${logs_a[@]}"
do
  log_date=`echo "$log" | cut -d'.' -f2`
  # Remove the hour
  log_date="${log_date%-*}"
  log_dir="$DIR/$log_date/"

  # create sub-directory for logs of the day
  if [ ! -d "$log_dir" ]; then
    mkdir "$log_dir"
  fi

  # download logfile from s3
  aws s3 cp "$BUCKET_URL/$log" "$log_dir"

  # process the log
  goaccess_opts=( \
    --keep-db-files \
    --load-from-disk \
    --db-path "$log_dir" \
    -a \
    # set the following if ther is not config file for goaccess
    --time-format='%H:%M:%S' \
    --date-format='%Y-%m-%d' \
    --log-format='%d\t%t\t%^\t%b\t%h\t%m\t%^\t%r\t%s\t%R\t%u\t%^' \
  )

  zcat -f "$log_dir/$log" | goaccess "${goaccess_opts[@]}" > "$log_dir/report_$log_date.html"
  goaccess "${goaccess_opts[@]}" -o json > "$log_dir/report_$log_date.json"
  
  # remove remote logfile
  # aws s3 rm "$BUCKET_URL/$log" "$log_dir" # TODO: uncomment
  #break # TODO: remove this line
done

## install dependencies:
## goaccess
## repo for libgeoip
# add-apt-repository -y ppa:maxmind/ppa
# apt-get update
# apt-get install -y git autoconf libncursesw5-dev libgeoip-dev libtokyocabinet-dev zlib1g-dev libbz2-dev
# cd /vagrant
# autoreconf -fiv
# ./configure --enable-tcb=btree --enable-geoip --enable-utf8
# make
# make install
## aws
# wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py
# python /tmp/get-pip.py
# export LANGUAGE=en_US.UTF-8
# export LANG=en_US.UTF-8
# export LC_ALL=en_US.UTF-8
# locale-gen en_US.UTF-8
# dpkg-reconfigure locales
# pip install awscli
