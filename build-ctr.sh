#!/usr/bin/env bash

# Get Environment
source env.sh

main() {
	docker build \
		-t "$CTR_NAME:latest" \
		--build-arg USER_NAME=$(whoami) \
		--build-arg USER_ID=$(id -u) \
		--build-arg GROUP_ID=$(id -g) \
		"$CTR_CONTEXT_DIR"
	ok_or_die "ERROR: Container build failed"
}

main "$@"
