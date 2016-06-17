#!/bin/bash

set -eo pipefail

DATE=`date +%y-%m-%d`
log_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/"

# process the log
goaccess_opts=( \
  --keep-db-files \
  --load-from-disk \
  --db-path "$log_dir" \
  -a \
  # set the following if ther is not config file for goaccess
  --time-format='%H:%M:%S' \
  --date-format='%d/%m-%Y' \
  --log-format='%v\t%\t%h\t%^\t%x\t%U\t%^\t%^\t%u\t%^\t%^\t%^\t%^\t%^\t%^\t%^\t%^\t%^\t%^' \
)

#zcat -f "$log_dir/gyg_access.20160402.log.gz" | goaccess "${goaccess_opts[@]}" > "$log_dir/hd_ report.html"

cat "$log_dir/gyg_access.20160404.log" | goaccess "${goaccess_opts[@]}" > "$log_dir/hd_report.html"