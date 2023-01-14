#!/bin/bash -e

WORKDIR=$1
REV=$2

git -C $WORKDIR log --all --grep=revision=$REV\$ --format=%H
