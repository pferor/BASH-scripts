#!/bin/sh
#
# Shows Conkeror bookmarks
# 
# Requirements:
#  - sqlite
# 

DEFAULT_PROFILE="00000000.default"

if [[ ${#} -eq 0 ]]
then
    ## Gessing there are only one "default" profile
    PROFILE="${DEFAULT_PROFILE}"
else
    PROFILE="${1}"
fi

## Default dir. and files
DIR_CONKEROR="${HOME}/.conkeror.mozdev.org/conkeror/${PROFILE}/"
FILE_BOOKMARKS="${DIR_CONKEROR}places.sqlite"

## If the file is not copied and Conkeror is still running, then a
## locked database error will be prompt.
## The copy of the database file is needed

if [[ ! -e ${FILE_BOOKMARKS} ]]
then
    echo "Error: Cannot find bookmarks file for profile '$PROFILE'" > /dev/stderr
    exit 1
fi

cp ${FILE_BOOKMARKS} /tmp/places.sqlite.tmp
sqlite3 /tmp/places.sqlite.tmp '
    SELECT b.id, p.url, p.title, b.title
    FROM moz_bookmarks
    b INNER JOIN moz_places p ON b.fk = p.id
    ORDER BY b.id DESC;'


## Exits successfully
exit 0
