#!/bin/sh
set -e

DB_FILE=${DB_FILE:-writefreely.db}
CONFIG_FILE=config.ini
WRITEFREELY="/writefreely/writefreely -c $CONFIG_FILE"

if [ ! -s $CONFIG_FILE ]; then
  cp config.example.ini $CONFIG_FILE
  sed -i "s@\$HOST@${HOST:-http://localhost:8080}@" $CONFIG_FILE
  sed -i "s@\$DB_FILE@$DB_FILE@" $CONFIG_FILE
  sed -i "s@\$SITE_NAME@${SITE_NAME:-WriteFreely}@" $CONFIG_FILE
  sed -i "s@\$SITE_DESC@${SITE_DESC:-A place to write freely.}@" $CONFIG_FILE
fi

if [ ! -s /data/$DB_FILE ]; then
  $WRITEFREELY -init-db
  $WRITEFREELY -create-admin ${USERNAME:-writefreely}:${PASSWORD:-writefreely}
fi

$WRITEFREELY -gen-keys
$WRITEFREELY
