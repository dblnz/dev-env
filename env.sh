#!/bin/bash

get_current_dir() {
	echo $(cd $(dirname "$0") && pwd)
}

say() {
	echo "$*"
}

die() {
	say "$*"
	exit -1
}

ok_or_die() {
	[[ $? -eq 0 ]] || die
}

CTR_NAME=dev
CURRENT_DIR=$(get_current_dir)
CTR_CONTEXT_DIR=$CURRENT_DIR
DOCKERFILE=$CTR_CONTEXT_DIR/Dockerfile
