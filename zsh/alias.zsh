###############################################################################
# ALIASES
###############################################################################

# Functions

take () {
    mkdir $1
    cd $1
}

function aws-switch() {
    case ${1} in
        "" | "clear")
            export AWS_PROFILE=""
            ;;
        *)
            export AWS_PROFILE="${1}"
            ;;
    esac
}

function in() {
  echo -e "$text\n\n" >> "$HOME/txt/vimwiki/inbox.md"
}


function ril() {
  title=$(curl -sL "$*" |perl -l -0777 -ne 'print $1 if /<title.*?>\s*(.*?)\s*<\/title/si' |recode html)
  echo "- [ ] [$title]($*)" >> "$HOME/txt/vimwiki/ReadingList.md"
  pandoc -o "$HOME/Dropbox/ReadingList.html" "$HOME/txt/vimwiki/ReadingList.md"
}

function track() {
  echo "- $*" >> "$HOME/txt/vimwiki/diary/$(date +'%Y-%m-%d').md"
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

#
# FZF
# Most taken from https://github.com/junegunn/fzf/wiki/Examples
#

if (( $+commands[fzf] )) ; then
  # fe [FUZZY PATTERN] - Open the selected file with the default editor
  #   - Bypass fuzzy finder if there's only one match (--select-1)
  #   - Exit if there's no match (--exit-0)
  fe() {
    local files
    IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
    [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
  }

  j() {
    if [[ "$#" -ne 0 ]]; then
        cd $(autojump $@)
        return
    fi
    cd "$(autojump -s | sed '/_____/Q; s/^[0-9,.:]*\s*//' |  fzf --height 40% --reverse --inline-info)" 
  }

  # vf - fuzzy open with vim from anywhere
  # ex: vf word1 word2 ... (even part of a file name)
  # zsh autoload function
  vf() {
    local files

    files=(${(f)"$(locate -Ai -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1 -m)"})

    if [[ -n $files ]]
    then
       vim -- $files
       print -l $files[1]
    fi
  }

  # vg - fuzzy open with vim with ag
  # ex: vg search_string
  # zsh autoload function
  vg() {
    local file

    file="$(ag --nobreak --noheading $@ | fzf -0 -1 | awk -F: '{print $1 " +" $2}')"

    if [[ -n $file ]]
    then
       vim $file
    fi
  }

  # fd - cd to selected directory
  fd() {
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune \
      -o -type d -print 2> /dev/null | fzf +m) &&
    cd "$dir"
  }

  # cf - fuzzy cd from anywhere
  # ex: cf word1 word2 ... (even part of a file name)
  # zsh autoload function
  cf() {
    local file

    file="$(locate $@ | grep --null -vE '~$' | fzf --read0 -0 -1)"

    if [[ -n $file ]]
    then
       if [[ -d $file ]]
       then
          cd -- $file
       else
          cd -- ${file:h}
       fi
    fi
  }

  # fh - repeat history
  fh() {
    print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
  }

  # tm - create new tmux session, or switch to existing one. Works from within tmux too. (@bag-man)
  # `tm` will allow you to select your tmux session via fzf.
  # `tm irc` will attach to the irc session (if it exists), else it will create it.

  tm() {
    [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
    if [ $1 ]; then
      tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
    fi
    session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
  }

fi
