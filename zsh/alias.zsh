###############################################################################
# ALIASES
###############################################################################

# Functions

take () {
    mkdir $1
    cd $1
}

## Convenience and Safety
alias ls='ls --color'
alias rm='rm -I'

if [[ ${OSTYPE} == linux* ]]; then
  alias chmod='chmod --preserve-root -v'
  alias chown='chown --preserve-root -v'
fi

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
