source ~/.zplug/init.zsh

zplug "supercrabtree/k"
zplug "denysdovhan/spaceship-prompt", use:spaceship.zsh, from:github, as:theme
zplug "lukechilds/zsh-nvm"
zplug "twang817/zsh-ssh-agent"
zplug "akoenig/npm-run.plugin.zsh"
zplug "MikeDacre/tmux-zsh-vim-titles"
zplug "zsh-users/zsh-autosuggestions"

alias gitc-ammend="git commit --amend"
alias gitc-update-branches="git remote update origin --prune"
alias pacman-clean="sudo pacman -Sc"
alias pacman-remove="sudo pacman -Rs"
alias pacman-search="pacman -Ss"
alias pacman-install="sudo pacman -S"
alias pacman-ugrade="sudo pacman -Syu"
alias pacman-aur="makepkg -sri ?"
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ll='ls --color -h --group-directories-first -l --time-style="+%m-%d-%y %H:%m:%S" -p -a'

export LESS='-R '
export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s" # 'source-highlight' package
#export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
#export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
#export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
#export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
#export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
#export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
#export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

PROMPT='%B%m%~%b$(git_super_status) %# '

bindkey -v
bindkey '^R' history-incremental-search-backward
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey "${terminfo[kdch1]}" delete-char

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000

setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
#setopt HIST_BEEP                 # Beep when accessing nonexistent history.

SPACESHIP_GCLOUD_SHOW=false

export DENO_INSTALL="/home/anders/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

zplug load
