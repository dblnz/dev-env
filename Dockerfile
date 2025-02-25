FROM fedora:latest AS base

ARG USER_NAME
ARG USER_ID
ARG GROUP_ID
ARG GO_VERSION="1.24.0"
ARG HOSTNAME=dev

ENV HOME=/home/${USER_NAME}
ENV GOPATH="/usr/local/gopath"
ENV PATH="$HOME/.cargo/bin:/usr/local/go/bin:${GOPATH}/bin:$PATH"
ENV EDITOR=nvim
ENV LANG="C.UTF-8"

RUN dnf -y update \
	&& dnf -y install \
		ansible \
		bash-completion \
		binutils-devel \
		bison \
		clang-devel \
		cmake \
		elfutils-devel \
		fd-find \
		file \
		findutils \
		flex \
		fzf \
		g++ \
		gcc \
		git \
		iperf3 \
		iproute \
		jq \
		libcurl-devel \
		llvm-devel \
		lsof \
		make \
		man-pages \
		neovim \
		net-tools \
		nmap-ncat \
		openssl-devel \
		procps \
		python3 \
		python3-devel \
		python3-pip \
		python3-virtualenv \
		ripgrep \
		sudo \
		tmux \
		tree \
		vim-common \
		which \
		zlib-devel

RUN python3 -m pip install setuptools wheel \
	&& python3 -m pip install \
		boto3 \
		neovim \
		nsenter \
		pycodestyle \
		pydocstyle \
		pylint \
		pytest \
		pytest-timeout \
		python-language-server \
		requests \
		requests-unixsocket \
		retry

FROM base AS dev

RUN groupadd -g $GROUP_ID $USER_NAME \
	; group_name=$(getent group ${GROUP_ID} | cut -d: -f1) \
	&& useradd -l -u ${USER_ID} -d "${HOME}" -g "$group_name" -s /bin/bash ${USER_NAME} \
	&& chown -R "${USER_NAME}:$group_name" /home/${USER_NAME} \
	&& echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
	&& curl "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz" | tar -C /usr/local -zx

USER ${USER_NAME}

ADD configs ${HOME}/configs

# Tools installation 
RUN pushd ${HOME}/configs \
        && whoami \
        && ansible-playbook playbook.yml -u $USER_NAME \
        && popd

# Configure GIT signing key
RUN git config --global commit.gpgsign true
RUN git config --global gpg.format ssh
RUN git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
RUN touch ~/.ssh/allowed_signers

RUN pub_key=$(cat ${HOME}/.ssh/id_rsa.pub) \
	 && email=$(git config user.email) \
	 && echo "${email} ${pub_key}" > ${HOME}/.ssh/allowed_signers \
     && echo $(cat ${HOME}/.ssh/allowed_signers) \
	 && git config --global user.signingkey "${pub_key}"

WORKDIR "$HOME/src"
