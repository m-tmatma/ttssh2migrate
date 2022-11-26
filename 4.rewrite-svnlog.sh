#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

WORKDIR=$SCRIPT_DIR/workdir
SRC_REPO=$WORKDIR/ttssh2.org
DST_REPO=$WORKDIR/ttssh2
SRC_LOG_DIR=$WORKDIR/ttssh2.srclog
DST_LOG_DIR=$WORKDIR/ttssh2.dstlog

rm   -rf $SRC_LOG_DIR $DST_LOG_DIR
mkdir -p $SRC_LOG_DIR
mkdir -p $DST_LOG_DIR

YOUNGEST=$(svnlook youngest $DST_REPO)
echo $YOUNGEST
for rev in `seq 1 $YOUNGEST`
do
    SRC_LOG=$SRC_LOG_DIR/r$rev.log
    DST_LOG=$DST_LOG_DIR/r$rev.log

    #echo processing $rev
    svnlook log -r $rev $DST_REPO > $SRC_LOG
    cat $SRC_LOG | $SCRIPT_DIR/convert-svn-log.py > $DST_LOG
    diff $SRC_LOG $DST_LOG
    if [ $? -ne 0 ]; then
        echo replacing log for $rev
        svnadmin setlog --bypass-hooks $DST_REPO -r $rev $DST_LOG
    fi
done

svn log -v file://$DST_REPO > $WORKDIR/svn-new-rewrite.log
