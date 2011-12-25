#!/bin/sh
#
# Usage:
#
#   $ tinyurl.sh <http://very/long/uri>
#


## Validation
WGET_BIN="/usr/bin"  ## Where wget is
if [[ ! -x "${WGET_BIN}" ]]
then
    echo "$(basename ${0}): wget not found" >&2
    exit 1
fi


## Get argument
if [[ ${#} -lt 1 ]]
then
    echo "$(basename ${0}): No URI." >&2
    exit 1
fi

if [[ "${1:0:4}" != "http" ]]
then
    echo "Usage: $(basename ${0}) <URI>" >&2
    exit 1
fi


## Wget config...

USERAGENT="Mozilla/5.0 (Windows NT 6.1; rv:2.0b7pre) Gecko/20100921 \
Firefox/4.0b7pre"

REFERER="http://tinyurl.com/"

HEADER_0="Accept: \
text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,video/x-mng,image/png,image/jpeg,image/gif;q=0.2,*/*;q=0.1"

HEADER_1="Accept-Language: en"

HEADER_2="Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7"

HEADER_3="Content-Type: application/x-www-form-urlencoded"


## Wget do the stuff
wget -q -O - \
-U "${USERAGENT}" \
--header="${HEADER_0}" \
--header="${HEADER_1}" \
--header="${HEADER_2}" \
--referer="${REFERER}" \
--header="${HEADER_3}" \
--post-data="url=$*" \
http://tinyurl.com/create.php \
| sed -n 's/.*\(http:\/\/tinyurl.com\/[a-z0-9][a-z0-9]*\).*/\1/p' \
| uniq


## Exit successfully
exit 0

