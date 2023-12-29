###############################################################################
# ALIASES
###############################################################################

# Functions

function light() {
  touch "$HOME/light"
  tmux source-file "$HOME/.tmux/tmux.conf"
  # gsed -i 's/\*gruvbox_dark/\*onehalf_light/' "$HOME/.config/alacritty/alacritty.yml"
  ln -nfs "$HOME/.config/alacritty/onehalf-light.yml" "$HOME/.config/alacritty/colors.yml"
}

function dark() {
  rm -f "$HOME/light"
  tmux source-file "$HOME/.tmux/tmux.conf"
  # gsed -i 's/\*onehalf_light/\*gruvbox_dark/' "$HOME/.config/alacritty/alacritty.yml"
  ln -nfs "$HOME/.config/alacritty/gruvbox-dark.yml" "$HOME/.config/alacritty/colors.yml"
}

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
  alias chmod='chmod --preserve-root -v'
  alias chown='chown --preserve-root -v'
fi

if [[ ${OSTYPE} == darwin* ]]; then
  alias rm='rm -i'

  alias utc="sudo systemsetup -settimezone GMT"
  alias cst="sudo systemsetup -settimezone America/Chicago"

  # Show/hide hidden files in Finder
  alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
  alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
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
    if [[ ${OSTYPE} == darwin* ]]; then
      cd "$(autojump -s all | gsed '/_____/Q; s/^[0-9,.:]*\s*//' |  fzf --height 40% --reverse --inline-info)" 
    else
      cd "$(autojump -s all | sed '/_____/Q; s/^[0-9,.:]*\s*//' |  fzf --height 40% --reverse --inline-info)" 
    fi
  }

  # vf - fuzzy open with files from current directory
  # zsh autoload function
  vf() {
    if [ -z "$1" ]; then
      file="$(fd -t file . |fzf --height 40% --reverse --inline-info)"
      vim "$file" 
    else
      vim "$1"
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

  #
  # Git
  #

  # git commit browser
  fshow() {
    git log --graph --color=always \
        --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
        --bind "ctrl-m:execute:
                  (grep -o '[a-f0-9]\{7\}' | head -1 |
                  xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                  {}
  FZF-EOF"
  }

  # fbr - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
  fbr() {
    local branches branch
    branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
    branch=$(echo "$branches" |
             fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
    git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
  }

  #kubernetes contexts switcher
  kcs() {
      local context="$(kubectl config get-contexts | fzf --multi --ansi -i -1 --height=50% --reverse -0 --header-lines=1 --inline-info --border | awk '{print $1}')"
      eval kubectl config set current-context "${context}"
  }

  cds() {
    local file

    file="$(fd . --type directory ~/git/robin/sysops | fzf)"
    if [[ -n $file ]]
    then
      cd -- $file
    fi
  }

fi
