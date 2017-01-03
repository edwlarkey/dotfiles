###############################################################################
# ALIASES
###############################################################################

# Functions

take () {
    mkdir $1
    cd $1
}

## Convenience and Safety
if [[ ${OSTYPE} == linux* ]]; then
  alias rm='rm -I'
fi

if [[ ${OSTYPE} == darwin* ]]; then
  alias rm='rm -i'
fi

if [[ ${OSTYPE} == linux* ]]; then
  alias chmod='chmod --preserve-root -v'
  alias chown='chown --preserve-root -v'
fi

## Docker
alias dc='docker-compose'

## mutt
alias email='mutt -F ~/.mutt/work'
alias gmail='mutt -F ~/.mutt/gmail'
alias edwmail='mutt -F ~/.mutt/edwlarkey'
alias mac='mutt -F ~/.mutt/mac'

## git
alias gac="git add . && git commit -v"

## Calendar
alias c="textcal open"

# alias life="cd ~/Dropbox/txt"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# generate tags
alias new_work_tags="ctags -R -f ~/.worktags --fields=+l --file-scope=no ~/.tag_files/work"
alias ctags="ctags -R -f ./tags --fields=+l"

# Fast ssh
alias admin="ssh bd_admin@admin.builderdesigns.com"
alias backups="ssh bd_admin@10.1.10.254"

#
# ls Colours
#

if (( ${+commands[dircolors]} )); then
  # GNU
  if [[ -s ${HOME}/.dir_colors ]]; then
    eval "$(dircolors --sh ${HOME}/.dir_colors)"
  else
    eval "$(dircolors --sh)"
  fi

  alias ls='ls --classify --color=auto'
else
  # BSD

  # colors for ls and completion
  export LSCOLORS='exfxcxdxbxGxDxabagacad'
  export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'
  # stock OpenBSD ls does not support colors at all, but colorls does.
  if [[ $OSTYPE == openbsd* ]]; then
    if (( ${+commands[colorls]} )); then
      alias ls='colorls -G'
    fi
  else
    alias ls='ls -G'
  fi
fi
