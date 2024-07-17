FROM fedora:latest AS base

ARG USER_NAME
ARG USER_ID
ARG GROUP_ID
ARG GIT_KEY="id_github_rsa_4096_0"
ARG RUST_TOOLCHAIN="stable"
ARG GO_VERSION="1.21.9"
ARG HOSTNAME=dev

ENV HOME=/home/${USER_NAME}
ENV GOPATH="/usr/local/gopath"
ENV PATH="$HOME/.cargo/bin:/usr/local/go/bin:${GOPATH}/bin:$PATH"
ENV EDITOR=nvim
ENV LANG="C.UTF-8"

RUN sed -i -E "/tsflags=*nodocs/ d" /etc/dnf/dnf.conf; \
	dnf -y reinstall \
		curl \
		openssh-clients \
		openssl \
		pkgconf \
		tar

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


# Copy generated key for git ssh connection
COPY ${GIT_KEY} /home/${USER_NAME}/.ssh/id_rsa
COPY ${GIT_KEY}.pub /home/${USER_NAME}/.ssh/id_rsa.pub
RUN group_name=$(getent group ${GROUP_ID} | cut -d: -f1) && chown -R ${USER_NAME}:$group_name /home/${USER_NAME}/.ssh
RUN echo "Host *github.com\n\tStrictHostKeyChecking no\n" >> /home/${USER_NAME}/.ssh/config

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

FROM dev AS final

RUN mkdir -p $HOME/.tmux/plugins \
        && git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm \
        && bash -c "export TMUX_PLUGIN_MANAGER_PATH=$HOME/.tmux/plugins; $HOME/.tmux/plugins/tpm/bin/install_plugins" \
        && ln -s /src "$HOME/src"

RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim \
        ~/.local/share/nvim/site/pack/packer/start/packer.nvim \ 
    && nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' \
    # First time it throws error
    || nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' \
    && nvim --headless -c "TSUpdate" -c "MasonUpdate" -c "qall"

WORKDIR "$HOME/src"
