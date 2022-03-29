FROM fedora:latest

ARG USER_NAME
ARG USER_ID
ARG GROUP_ID
ARG RUST_TOOLCHAIN="stable"
ARG GO_VERSION="1.14.1"
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

ADD bashrc ${HOME}/.bashrc
ADD init.vim ${HOME}/.config/nvim/init.vim
ADD tmux.conf ${HOME}/.tmux.conf
ADD gitconfig ${HOME}/.gitconfig

RUN groupadd -g $GROUP_ID $USER_NAME \
	; group_name=$(getent group ${GROUP_ID} | cut -d: -f1) \
	&& useradd -l -u ${USER_ID} -d "${HOME}" -g "$group_name" -s /bin/bash ${USER_NAME} \
	&& chown -R "${USER_NAME}:$group_name" /home/${USER_NAME} \
	&& echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
	&& curl "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz" | tar -C /usr/local -zx


USER ${USER_NAME}

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain "${RUST_TOOLCHAIN}" \
	&& rustup target add x86_64-unknown-linux-musl \
	&& rustup component add rustfmt \
	&& rustup component add clippy-preview \
	&& rustup component add rls rust-analysis rust-src \
	&& mkdir -p "$HOME/tmp" \
		&& cd "$HOME/tmp" \
		&& cargo install cargo-audit \
		&& cargo install cargo-kcov \
		&& cargo kcov --print-install-kcov-sh | sh \
	&& cd "$HOME" \
	&& rm -rf "$HOME/tmp" \
	&& cargo install bindgen

RUN mkdir -p $HOME/.local/share/nvim/site/autoload \
	&& curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
	&& cat $HOME/.config/nvim/init.vim | sed -n "/^call plug#begin/,/^call plug#end/ p" > /tmp/plug-init.vim \
		&& nvim --headless -u /tmp/plug-init.vim +"PlugInstall --sync" +"UpdateRemotePlugins" +qall \
		&& rm -f /tmp/plug-init.vim \
	&& mkdir -p $HOME/.tmux/plugins \
		&& git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm \
		&& bash -c "export TMUX_PLUGIN_MANAGER_PATH=$HOME/.tmux/plugins; $HOME/.tmux/plugins/tpm/bin/install_plugins" \
	&& ln -s /src "$HOME/src" \
	&& rm "$HOME/.git-credentials"

WORKDIR "$HOME/src"
