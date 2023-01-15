#!/bin/sh

WORKDIR=$1
REV=$2

git -C $WORKDIR rev-list --all | xargs -r git -C $WORKDIR log --grep "revision=$REV\$"  --format=%H | uniq

