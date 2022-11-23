#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

WORKDIR=$SCRIPT_DIR/workdir
SRC_REPO=$WORKDIR/ttssh2.org
DST_REPO=$WORKDIR/ttssh2

YOUNGEST=$(svnlook youngest $DST_REPO)
echo $YOUNGEST
for rev in `seq 1 $YOUNGEST`
do
    echo processing $rev
    svnlook log -r $rev $DST_REPO | \
        python3 -c 'import sys,re; [print(re.sub(r"r(\d+)",r"https://osdn.net/projects/ttssh2/scm/svn/commits/\1",l,1),end="") for l in sys.stdin]' | \
        python3 -c 'import sys,re; [print(re.sub(r"#(\d+)",r"https://osdn.net/projects/ttssh2/ticket/\1"         ,l,1),end="") for l in sys.stdin]' > $WORKDIR/revlog.txt
    svnadmin setlog  --bypass-hooks $DST_REPO -r $rev $WORKDIR/revlog.txt
done

svn log -v file://$DST_REPO > $WORKDIR/svn-new-rewrite.log
