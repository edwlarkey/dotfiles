DOTFILES := $(shell pwd)

all: dirs bin zsh mutt tmux alacritty x vim  ## Set up config for everything except git
	git submodule init
	git submodule update
	git submodule update --init --recursive

alacritty:  ## Link alacritty config
	ln -nfs $(DOTFILES)/alacritty.yml ${HOME}/.config/alacritty/alacritty.yml

bin:  ## Link bin directory
	ln -nfs $(DOTFILES)/bin ${HOME}/bin

dirs:  ## Make $HOME/.config directory
	mkdir -p ${HOME}/.config

.PHONY: git
git:  ## Set up git
	mkdir -p ${HOME}/.config/git
	mkdir -p ${HOME}/git
	ln -nfs $(DOTFILES)/git/gitconfig ${HOME}/.gitconfig
	git config --global core.editor vim
	git config  --file ${HOME}/.config/git/config commit.template $(DOTFILES)/git/git-commit-template
	@while [ -z "$$LOCATION" ]; do \
		read -r -p "Set up git for (home) or (work): " LOCATION;\
	done && \
	ln -nfs $(DOTFILES)/git/"$$LOCATION"-config ${HOME}/.config/git/config

mutt:  ## Link mutt config
	ln -nfs $(DOTFILES)/mutt ${HOME}/.mutt

starship:  ## Link starship config
	ln -nfs $(DOTFILES)/starship.toml ${HOME}/.config/starship.toml

tmux:  ## Link tmux config
	ln -nfs $(DOTFILES)/tmux/tmux.conf ${HOME}/.tmux.conf

.PHONY: vim
vim:  ## Set up vim config and install plugins
	mkdir -p ${HOME}/.vim-backup
	mkdir -p ${HOME}/.vim-undo
	mkdir -p ${HOME}/.vim-swap
	ln -nfs $(DOTFILES)/vim ${HOME}/.vim
	ln -nfs $(DOTFILES)/vim/vimrc ${HOME}/.vimrc
	vim +PlugInstall +qall

zsh: starship  ## Link zsh config
	ln -nfs $(DOTFILES)/zsh ${HOME}/.zsh
	ln -nfs $(DOTFILES)/zsh/zlogin ${HOME}/.zlogin
	ln -nfs $(DOTFILES)/zsh/zlogout ${HOME}/.zlogout
	ln -nfs $(DOTFILES)/zsh/zprofile ${HOME}/.zprofile
	ln -nfs $(DOTFILES)/zsh/zshrc ${HOME}/.zshrc
	ln -nfs $(DOTFILES)/zsh/zshenv ${HOME}/.zshenv

x:  ## Link X config
	ln -nfs $(DOTFILES)/xinitrc ${HOME}/.xinitrc

##@ Helpers

.PHONY: help
help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

