# Katz's zshrc for all

## Environment variable configuration
#
# LANG
#
export LANG=ja_JP.UTF-8
case ${UID} in
0)
    LANG=C
    ;;
esac

#
# PATH
#
export PATH=${HOME}/bin:$PATH
# no duplicate
typeset -U path cdpath fpath manpath


## Default shell configuration
#
# set prompt
#
autoload -Uz colors
colors
setopt prompt_subst
case ${UID} in
0)
    PROMPT="%6F$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') %1F%~#%f "
    PROMPT2="%1F%_#%f "
    SPROMPT="%3F%r is correct? [n,y,a,e]:%f "
    ;;
*)
    PROMPT="%1F%n%%%f "
    PROMPT2="%1F%_%%%f "
    SPROMPT="%3F%r is correct? [n,y,a,e]:%f "
    RPROMPT="%3F[%(4~,%-1~/.../%2~,%~)]%f"

    # change color for vimode
    function zle-line-init zle-keymap-select {
        case $KEYMAP in
            vicmd)
                PROMPT="%5F%n%%%f "
                ;;
            main|viins)
                PROMPT="%1F%n%%%f "
                ;;
        esac
        zle reset-prompt
    }
    zle -N zle-line-init
    zle -N zle-keymap-select

    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="%6F$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
    ;;
esac

# auto change directory
#
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
#
setopt auto_pushd
setopt pushd_ignore_dups

# command correct edition before each completion attempt
#
setopt correct
setopt correct_all

# compacked complete list display
#
setopt list_packed
setopt list_types
setopt auto_list

# no remove postfix slash of command line
#
setopt noautoremoveslash

# no beep sound when complete list displayed
#
setopt nolistbeep

# other complitions
#
setopt magic_equal_subst
setopt auto_param_keys
setopt auto_param_slash


## Keybind configuration
#
# emacs like keybind (e.x. Ctrl-a gets to line head and Ctrl-e gets
#   to end) and something additions
#
bindkey -v
bindkey "^[[1~" beginning-of-line # Home gets to line head
bindkey "^[[4~" end-of-line # End gets to line end
bindkey "^[[3~" delete-char # Del
bindkey "^W" forward-word
bindkey "^B" backward-word

# historical backward/forward search with linehead string binded to ^P/^N
#
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

# reverse menu completion binded to Shift-Tab
#
bindkey "\e[Z" reverse-menu-complete


## Command history configuration
#
HISTFILE=${HOME}/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data


## Completion configuration
#
fpath=(${HOME}/.zsh/functions/Completion ${fpath})
autoload -Uz compinit
compinit -u


## zsh editor
#
autoload -Uz zed


## Prediction configuration
#
#autoload -Uz predict-on
#predict-off


## Alias configuration
#
# expand aliases before completing
#
setopt complete_aliases     # aliased ls needs if file/dir completions work

alias where="command -v"
alias j="jobs -l"

case "${OSTYPE}" in
freebsd*|darwin*)
    alias ls="ls -G -w"
    ;;
linux*)
    alias ls="ls --color"
    ;;
esac

alias la="ls -a"
alias lf="ls -F"
alias ll="ls -l"

alias du="du -h"
alias df="df -h"

alias su="su -l"


## terminal configuration
#

case "${TERM}" in
xterm|xterm-color|xterm-256color|screen)
    export LSCOLORS=ExFxCxdxBxegedabagacad
    export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34'
    zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
    ;;
kterm-color)
    stty erase '^H'
    export LSCOLORS=ExFxCxdxBxegedabagacad
    export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34'
    zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
    ;;
kterm)
    stty erase '^H'
    ;;
cons25)
    unset LANG
    export LSCOLORS=ExFxCxdxBxegedabagacad
    export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34'
    zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
    ;;
jfbterm-color)
    export LSCOLORS=gxFxCxdxBxegedabagacad
    export LS_COLORS='di=01;36:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34'
    zstyle ':completion:*' list-colors 'di=;36;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
    ;;
esac

# set terminal title including current directory
#
case "${TERM}" in
xterm|xterm-color|xterm-256color|kterm|kterm-color|screen)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac


## load user .zshrc configuration file
#
case "${OSTYPE}" in
darwin*)
    [ -f ${HOME}/.zshrc.osx ] && source ${HOME}/.zshrc.osx
    ;;
freebsd*)
    [ -f ${HOME}/.zshrc.freebsd ] && source ${HOME}/.zshrc.freebsd
    ;;
esac
 
[ -f ${HOME}/.zshrc.vcs ] && source ${HOME}/.zshrc.vcs
[ -f ${HOME}/.zshrc.mine ] && source ${HOME}/.zshrc.mine

