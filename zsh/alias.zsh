###############################################################################
# ALIASES [I could do this in a plugin I guess]
###############################################################################

# Functions

take () {
    mkdir $1
    cd $1
}

## MUTT
alias email='mutt -F ~/.mutt/work'
alias gmail='mutt -F ~/.mutt/gmail'
alias edwmail='mutt -F ~/.mutt/edwlarkey'
alias mac='mutt -F ~/.mutt/mac'

## GIT extra
alias gac="git add . && git commit -v"

## Calendar
alias c="textcal open"

## todo.txt
alias life="cd ~/Dropbox/txt/life"

## work vs home
if [[ $(uname) = 'Linux' ]]; then
    alias t="~/Dropbox/txt/life/todo/.todo.sh -d ~/Dropbox/txt/life/todo/.todo_work.cfg"
fi

if [[ $(uname) = 'Darwin' ]]; then
    alias t="~/Dropbox/txt/life/todo/.todo.sh -d ~/Dropbox/txt/life/todo/.todo.cfg"
fi

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# generate tags
alias new_work_tags="ctags -R -f ~/.worktags --fields=+l --file-scope=no ~/.tag_files/work"
alias ctags="ctags -R -f ./tags --fields=+l"

# Fast ssh
alias admin="ssh bd_admin@admin.builderdesigns.com"
alias backups="ssh bd_admin@10.1.10.254"
