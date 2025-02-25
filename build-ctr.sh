#!/usr/bin/env bash

# Get Environment
source env.sh

# Build the container
build_container() {
    USER_NAME=$1
    USER_ID=$2
    GROUP_ID=$3

	docker build \
		-t "$CTR_NAME:latest" \
        --build-arg CONFIGS_DIR="${CONFIGS_DIR}" \
		--build-arg USER_NAME=${USER_NAME} \
		--build-arg USER_ID=${USER_ID} \
		--build-arg GROUP_ID=${GROUP_ID} \
        .

	ok_or_die "ERROR: Container build failed"
}

main() {
    # Check the parameters
    if [[ $# -eq 3 ]]; then
        # Build the container with the provided arguments
        build_container "$@"
    elif [[ $# -eq 0 ]]; then
        # Build the container with the current user
        build_container "$CTR_CONTEXT_DIR" "$(whoami)" "$(id -u)" "$(id -g)"
    else
        die "Usage: $0 [CONFIGS_DIR USER_NAME USER_ID GROUP_ID]"
    fi
}

main "$@"
