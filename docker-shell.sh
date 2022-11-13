#!/bin/bash

function build_docker {
    docker build -t svn2git_plus `pwd`/docker
}

function run_docker {
    COMMON_PARAM=$1
    mkdir -p `pwd`/workdir
    docker run --rm \
        -e LOCAL_UID=$(id -u $USER) -e LOCAL_GID=$(id -g $USER) \
        $COMMON_PARAM -v `pwd`/workdir:/home/work \
        -w /home/work \
        svn2git_plus ${@:2}
}

function show_help {
    echo $0 build
    echo $0 bash
    echo $0 shell
    echo $0 migrate
}

case $1 in
  "build" ) build_docker ;;
  "bash"  ) run_docker -it bash ;;
  "shell" ) run_docker -it bash ;;
  "migrate" ) run_docker "" ./migrate.sh ;;
  *       ) show_help ;;
esac
