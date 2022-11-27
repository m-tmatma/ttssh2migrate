#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

WORKDIR=$SCRIPT_DIR/workdir
SRC_REPO=$WORKDIR/ttssh2.step2
DST_REPO=$WORKDIR/ttssh2
LOG_DIR=$(mktemp -d)
SRC_LOG_DIR=$LOG_DIR/log-ttssh2.step2
DST_LOG_DIR=$LOG_DIR/log-ttssh2

mkdir -p $SRC_LOG_DIR
mkdir -p $DST_LOG_DIR

rm -rf $DST_REPO
cp -a  $SRC_REPO $DST_REPO

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
        echo ------------------------------- $rev -----------------------------------------------
    fi
done

svn log -v file://$DST_REPO > $WORKDIR/svn-step2-rewrite.log

# change parent directory of $DST_REPO and archive it.
(cd $DST_REPO/.. && tar cfz $WORKDIR/ttssh2-svn-4-writelog.tar.gz $(basename $DST_REPO) )

# change log directory of $LOG_DIR and archive it.
(cd $LOG_DIR && tar cfz $WORKDIR/ttssh2-svn-4-log.tar.gz $(basename $SRC_LOG_DIR) $(basename $DST_LOG_DIR) )

# cleanup log dir.
rm -rf $LOG_DIR
