#!/usr/bin/env bash

# Get Environment
source env.sh

KEY_NAME=id_github_rsa_4096_0
GIT_KEY=${CTR_CONTEXT_DIR}/${KEY_NAME}

generate_key() {
	if [ ! -f ${GIT_KEY} ]; then
		ssh-keygen -t rsa -b 4096 -f ${GIT_KEY}
		# ssh-copy-id -i ./id_rsa_shared remoteuser@remotehost
	fi
}

main() {
	generate_key

	docker build \
		-t "$CTR_NAME:latest" \
		--build-arg USER_NAME=$(whoami) \
		--build-arg USER_ID=$(id -u) \
		--build-arg GROUP_ID=$(id -g) \
		--build-arg GIT_KEY="${KEY_NAME}" \
		"$CTR_CONTEXT_DIR"
	ok_or_die "ERROR: Container build failed"
}

main "$@"
