#!/bin/sh -xe

#./0.build-svn2git.sh
./1.mirror-ttssh2.sh
./2.filter-svndmp.sh
./3.svnlog.sh
./4.migrate.sh
./5.git-repack.sh
./6.extract-filenames.sh
