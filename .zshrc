source ~/.zplug/init.zsh

zplug "supercrabtree/k"
#zplug "olivierverdier/zsh-git-prompt", use:zshrc.sh, hook-build:"zplug clear"
zplug "denysdovhan/spaceship-prompt", use:spaceship.zsh, from:github, as:theme
zplug "lukechilds/zsh-nvm"
zplug "twang817/zsh-ssh-agent"
zplug "chrissicool/zsh-256color"
zplug "akoenig/npm-run.plugin.zsh"
zplug "MikeDacre/tmux-zsh-vim-titles"
zplug "zsh-users/zsh-autosuggestions"

alias gitc-ammend="git commit --amend"
alias gitc-update-branches="git remote update origin --prune"
alias lsl="ls -l"
alias pacman-clean="sudo pacman -Sc"
alias pacman-remove="sudo pacman -Rs"
alias pacman-search="pacman -Ss"
alias pacman-install="sudo pacman -S"
alias pacman-ugrade="sudo pacman -Syu"
alias pacman-aur="makepkg -sri ?"
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ls='ls --color -h --group-directories-first -l --time-style="+%m-%d-%y %H:%m:%S" -p -a'

export LESS='-R '
export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s" # 'source-highlight' package
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline]']']']']']']'

PROMPT='%B%m%~%b$(git_super_status) %# '

bindkey -v
bindkey '^R' history-incremental-search-backward
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey    "^[[3~"          delete-char
bindkey    "^[3;5~"         delete-char

zplug load --verbose
