#!/bin/sh -xe

./1.mirror-ttssh2.sh
./2.filter-svndmp.sh
./3.svnlog.sh
./4.migrate.sh
./6.git-repack.sh
./7.extract-filenames.sh
