#!/usr/bin/env bash

# Get Environment
source env.sh

SRC_DIR="$CURRENT_DIR/src"
CTR_SRC_DIR=/src

main() {
	local opt_attach
	local src_dir="$SRC_DIR"
	local ctr_src_dir="$CTR_SRC_DIR"

	# CLI args
	while [[ $# -gt  0 ]]; do
		case "$1" in
			-h|--help)
				echo "Usage: $0 [OPTIONS] SRC_DIR:CTR_SRC_DIR" 1>&2
				exit 1
				;;
			-a)
				opt_attach=true
				;;
			*)
				IFS=: read -ra parts <<< "$1"
				src_dir="$(cd "${parts[0]}" && pwd)"
				[[ -n "${parts[1]}" ]] && ctr_src_dir="${parts[1]}"
				;;
		esac
		shift
	done

	# Check if the src dir is valid
	[[ -d "$src_dir" ]] || die "Error: $src_dir - not a valid directory"

	# Try to attach to running ctr
	ctr_id=$(docker ps --filter "label=$CTR_NAME" --filter "volume=$src_dir" --format "{{.ID}}")
	if [[ -n "$ctr_id" ]]; then
		if [[ "$opt_attach" = true ]]; then
			echo "Attaching to running container $ctr_id ..."
			docker attach "$ctr_id"
		else
			echo "Opening new shell in running container $ctr_id ..."
			docker exec -it "$ctr_id" bash
		fi
		return $?
	fi

	# Start new container
	echo "Running $CTR_NAME:latest ..."
	echo "Bind-mounting sources from $src_dir to $ctr_src_dir ..."
	echo ""
	docker run -it --rm \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v "$src_dir:$ctr_src_dir" \
		--init \
		--privileged \
		--security-opt seccomp=unconfined \
		--ulimit core=0 \
		--hostname "$CTR_NAME" \
		--label "$CTR_NAME" \
		--workdir "$ctr_src_dir" \
		-e "TERM=xterm-256color" \
		-e "SHELL=/bin/bash" \
		$CTR_NAME:latest bash
}

main "$@"
