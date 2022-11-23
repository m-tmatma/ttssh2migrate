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
    #echo processing $rev
    svnlook log -r $rev $DST_REPO > $WORKDIR/revlog-org.txt
    cat  $WORKDIR/revlog-org.txt | \
        python3 -c 'import sys,re; [print(re.sub(r"r(\d+)",r"https://osdn.net/projects/ttssh2/scm/svn/commits/\1",l),end="") for l in sys.stdin]' | \
        python3 -c 'import sys,re; [print(re.sub(r"#(\d+)",r"https://osdn.net/projects/ttssh2/ticket/\1"         ,l),end="") for l in sys.stdin]' > $WORKDIR/revlog-new.txt

    diff $WORKDIR/revlog-org.txt $WORKDIR/revlog-new.txt
    if [ $? -ne 0 ]; then
        echo replacing log for $rev
        svnadmin setlog --bypass-hooks $DST_REPO -r $rev $WORKDIR/revlog-new.txt
    fi
done
rm -f $WORKDIR/revlog-org.txt $WORKDIR/revlog-new.txt

svn log -v file://$DST_REPO > $WORKDIR/svn-new-rewrite.log
