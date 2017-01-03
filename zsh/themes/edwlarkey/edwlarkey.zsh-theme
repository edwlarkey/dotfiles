# prompt style and colors based on Steve Losh's Prose theme:
# http://github.com/sjl/oh-my-zsh/blob/master/themes/prose.zsh-theme
#
# vcs_info modifications from Bart Trojanowski's zsh prompt:
# http://www.jukie.net/bart/blog/pimping-out-zsh-prompt
#
# git untracked files modification from Brian Carper:
# http://briancarper.net/blog/570/git-info-in-your-zsh-prompt

export VIRTUAL_ENV_DISABLE_PROMPT=1

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('$fg[blue]`basename $VIRTUAL_ENV`%{$reset_color%}') '
}
PR_GIT_UPDATE=1

setopt prompt_subst

autoload -U add-zsh-hook
# autoload -Uz vcs_info
autoload -Uz colors && colors

# enable VCS systems you use
# zstyle ':vcs_info:*' enable git

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
# zstyle ':vcs_info:*:prompt:*' check-for-changes true

PROMPT='
%{$fg[cyan]%}%n%{$reset_color%} at %{$fg[red]%}%m%{$reset_color%} in %{$fg[green]%}%~%{$reset_color%} on $(git-prompt)%{$reset_color%}$(virtualenv_info)%{$reset_color%} (%{$fg[magenta]%}$(chefvm current)%{$reset_color%})
%{$fg[red]%}>_%{$reset_color%} '
