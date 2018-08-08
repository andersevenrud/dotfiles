
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

PATH=$PATH:$HOME/.local/bin:~/.gem/ruby/2.3.0/bin


# Git aware command prompt
#export GITAWAREPROMPT=~/.bash/git-aware-prompt
#source "${GITAWAREPROMPT}/main.sh"
#export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "

# Commands
alias gitc-ammend="git commit --amend"
alias gitc-update-branches="git remote update origin --prune"
alias lsl="ls -l"
alias pacman-clean="sudo pacman -Sc"
alias pacman-remove="sudo pacman -Rs"
alias pacman-search="pacman -Ss"
alias pacman-install="sudo pacman -S"
alias pacman-ugrade="sudo pacman -Syu"
alias pacman-aur="makepkg -sri ?"

# Color output
alias diff='diff --color=auto'
alias grep='grep --color=auto'
#alias ls='ls --color=auto'
alias ls='ls --color -h --group-directories-first -l --time-style="+%m-%d-%y %H:%m:%S" -p -a'


# 'less' colors
export LESS='-R '
export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s" # 'source-highlight' package
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline]']']']']']']'

#NPM_PACKAGES="${HOME}/.npm-packages"
#PATH="$NPM_PACKAGES/bin:$PATH"

# Unset manpath so we can inherit from /etc/manpath via the `manpath` command
unset MANPATH # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

if [ -n "$DESKTOP_SESSION" ];then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export NODE_PATH=$NODE_PATH:`npm root -g`
