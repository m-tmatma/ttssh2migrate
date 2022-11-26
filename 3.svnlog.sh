#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

WORKDIR=$SCRIPT_DIR/workdir
SRC_REPO=$WORKDIR/ttssh2.org
DST_REPO=$WORKDIR/ttssh2

svn log -v file://$SRC_REPO > $WORKDIR/svn-org.log
svn log -v file://$DST_REPO > $WORKDIR/svn-step2.log
