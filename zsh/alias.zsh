###############################################################################
# ALIASES [I could do this in a plugin I guess]
###############################################################################

# Functions

take () {
    mkdir $1
    cd $1
}

## MUTT
alias mutt='mutt -F ~/.mutt/mac'
alias email='mutt -F ~/.mutt/work'
alias gmail='mutt -F ~/.mutt/gmail'
alias edwmail='mutt -F ~/.mutt/edwlarkey'

## GIT extra
alias gac="git add . && git commit -v"

## Calendar
alias c="textcal"
alias ec="textcal -s"

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

# RDP
alias rdp23='rdesktop -d smartcorp.net -u edlarkey -b -g 1440x900 10.10.1.23'
alias rdp30='rdesktop -d smartcorp.net -u edlarkey -b -g 1440x900 10.10.1.30'
alias luke='rdesktop -d hpdcs.local -u edwlarkey -b -g 1440x900 10.14.240.22'
alias leia='rdesktop -d hpdcs.local -u edwlarkey -b -g 1440x900 10.14.240.21'
alias rdp='rdesktop -d hpdcs.local -u edwlarkey -b -g 1440x900'
