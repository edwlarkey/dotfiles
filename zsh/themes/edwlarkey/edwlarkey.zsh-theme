# prompt style and colors based on Steve Losh's Prose theme:
# http://github.com/sjl/oh-my-zsh/blob/master/themes/prose.zsh-theme
#
# vcs_info modifications from Bart Trojanowski's zsh prompt:
# http://www.jukie.net/bart/blog/pimping-out-zsh-prompt
#
# git untracked files modification from Brian Carper:
# http://briancarper.net/blog/570/git-info-in-your-zsh-prompt

export VIRTUAL_ENV_DISABLE_PROMPT=1

function aws_info {
    [ $AWS_PROFILE ] && echo ' (AWS: '$fg[red]`basename $AWS_PROFILE`%{$reset_color%}') '
}

function vi_mode {
    case ${KEYMAP} in
      (vicmd)      echo ":  " ;;
      (main|viins) echo "+  ";;
      (*)          echo "+  " ;;
    esac
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo ' ('$fg[blue]`basename $VIRTUAL_ENV`%{$reset_color%}') '
}
PR_GIT_UPDATE=1

setopt prompt_subst

autoload -U add-zsh-hook
autoload -Uz colors && colors


function zle-line-init zle-keymap-select {
    PROMPT='
%{$fg[cyan]%}%n%{$reset_color%} at %{$fg[red]%}%m%{$reset_color%} in %{$fg[green]%}%30<...<%~%<<%{$reset_color%}$(git-prompt)%{$reset_color%}$(virtualenv_info)%{$reset_color%}$(aws_info)%{$reset_color%}
$(vi_mode)%{$fg[red]%}>_%{$reset_color%} '
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
