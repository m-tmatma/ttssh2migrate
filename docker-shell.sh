#!/bin/bash

function build_docker {
    docker build -t svn2git_plus `pwd`/docker
}

function run_docker {
    mkdir -p `pwd`/workdir
    docker run --rm \
        -e LOCAL_UID=$(id -u $USER) -e LOCAL_GID=$(id -g $USER) \
        -it -v `pwd`/workdir:/home/work \
        -w /home/work \
        svn2git_plus $@
}

function show_help {
    echo $0 build
    echo $0 bash
    echo $0 shell
    echo $0 migrate
}

case $1 in
  "build" ) build_docker ;;
  "bash"  ) run_docker bash ;;
  "shell" ) run_docker bash ;;
  "migrate" ) run_docker ./migrate.sh ;;
  *       ) show_help ;;
esac
