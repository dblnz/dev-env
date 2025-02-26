#!/bin/bash

get_current_dir() {
	cd "$(dirname "$0")" && pwd
}

say() {
	echo "$*"
}

die() {
	say "$*"
	exit 1
}

ok_or_die() {
	[[ $? -eq 0 ]] || die "$*"
}

CURRENT_DIR=$(get_current_dir)
REMOTE_CTR_NAME=ghcr.io/dblnz/dev-env:latest
LOCAL_CTR_NAME=dev-env
CTR_CONTEXT_DIR=$CURRENT_DIR
DOCKERFILE=$CTR_CONTEXT_DIR/Dockerfile
