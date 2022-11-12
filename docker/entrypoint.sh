#!/bin/bash

USER_ID=${LOCAL_UID:-1000}
GROUP_ID=${LOCAL_GID:-1000}
USERNAME=work
HOME_DIR=/home/work

echo "Starting with UID : $USER_ID, GID: $GROUP_ID"
useradd  -u $USER_ID -o -M $USERNAME
groupmod -g $GROUP_ID $USERNAME
export USER=$USERNAME
export HOME=$HOME_DIR

exec /usr/sbin/gosu $USERNAME "$@"

