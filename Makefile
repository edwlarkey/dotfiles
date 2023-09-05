DOTFILES := $(shell pwd)

mac: submodules dirs bin zsh tmux terminals vim nvim karabiner ## Set up config for everything except git - Mac

linux: submodules dirs bin zsh tmux terminals vim nvim wayland ## Set up config for everything except git - Linux

.PHONY: submodules
submodules:  ## Init and update all git submodules
	git submodule init
	git submodule update
	git submodule update --init --recursive

.PHONY: terminal
terminal: alacritty wezterm  ## Link all terminal config

.PHONY: alacritty
alacritty:  ## Link alacritty config
	ln -nfs $(DOTFILES)/alacritty ${HOME}/.config/alacritty

.PHONY: wezterm
wezterm:  ## Link wezterm config
	ln -nfs $(DOTFILES)/wezterm ${HOME}/.config/wezterm

.PHONY: qutebrowser
qutebrowser:  ## Link qutebrowser config
	ln -nfs $(DOTFILES)/qutebrowser ${HOME}/.config/qutebrowser

.PHONY: bin
bin:  ## Link bin directory
	ln -nfs $(DOTFILES)/bin ${HOME}/bin

.PHONY: dirs
dirs:  ## Make needed directories
	mkdir -p ${HOME}/.config
	mkdir -p ${HOME}/.config/git
	mkdir -p ${HOME}/.vim-backup
	mkdir -p ${HOME}/.vim-undo
	mkdir -p ${HOME}/.vim-swap

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

.PHONY: mutt
mutt:  ## Link mutt config
	ln -nfs $(DOTFILES)/mutt ${HOME}/.mutt

.PHONY: karabiner
karabiner:  ## Link wayland config
	ln -nfs $(DOTFILES)/karabiner ${HOME}/.config/karabiner

.PHONY: tmux
tmux:  ## Link tmux config
	ln -nfs $(DOTFILES)/tmux ${HOME}/.tmux
	ln -nfs $(DOTFILES)/tmux/tmux.conf ${HOME}/.tmux.conf

.PHONY: vim
vim:  ## Set up vim config and install plugins
	mkdir -p ${HOME}/.vim-backup
	mkdir -p ${HOME}/.vim-undo
	mkdir -p ${HOME}/.vim-swap
	ln -nfs $(DOTFILES)/vim ${HOME}/.vim
	ln -nfs $(DOTFILES)/vim/vimrc ${HOME}/.vimrc
	vim +PlugInstall +qall

.PHONY: nvim
nvim:  ## Set up vim config and install plugins
	ln -nfs ${DOTFILES}/nvim ${HOME}/.config/nvim
	mkdir -p ${HOME}/.local/share/nvim/session

.PHONY: starship
starship:  ## Link starship config
	ln -nfs $(DOTFILES)/starship.toml ${HOME}/.config/starship.toml

.PHONY: zsh
zsh: starship  ## Link zsh config
	ln -nfs $(DOTFILES)/zsh ${HOME}/.zsh
	ln -nfs $(DOTFILES)/zsh/zlogin ${HOME}/.zlogin
	ln -nfs $(DOTFILES)/zsh/zlogout ${HOME}/.zlogout
	ln -nfs $(DOTFILES)/zsh/zprofile ${HOME}/.zprofile
	ln -nfs $(DOTFILES)/zsh/zshrc ${HOME}/.zshrc
	ln -nfs $(DOTFILES)/zsh/zshenv ${HOME}/.zshenv

.PHONY: wayland
wayland:  ## Link wayland config
	ln -nfs $(DOTFILES)/sway ${HOME}/.config/sway
	ln -nfs $(DOTFILES)/waybar ${HOME}/.config/waybar
	ln -nfs $(DOTFILES)/wofi ${HOME}/.config/wofi
	ln -nfs $(DOTFILES)/hypr ${HOME}/.config/hypr

.PHONY: x
x:  ## Link X config
	ln -nfs $(DOTFILES)/xinitrc ${HOME}/.xinitrc

##@ Helpers

.PHONY: help
help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
