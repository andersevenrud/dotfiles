
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

PATH=$PATH:$HOME/.local/bin

export GITAWAREPROMPT=~/.bash/git-aware-prompt
source "${GITAWAREPROMPT}/main.sh"

#export PS1="\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "

# Powerline-like bar that I played around with
OFF="\033[0m"
YELLOW="\033[38;5;17m\033[48;5;11m"
GRAY="\033[38;5;15m\033[48;5;239m"
BLACK="\033[38;5;49m\033[48;5;234m"
TRIANGLE=$'\xee\x82\xb0'
TYELLOW="\033[38;5;11m\033[48;5;239m"
TGRAY="\033[38;5;239m\033[48;5;234m"
TWHITE="\033[38;5;234m\033[48;5;0m"

export PS1="${YELLOW} \u@\h ${TYELLOW}${TRIANGLE}${OFF}${GRAY} \w ${TGRAY}${TRIANGLE}${OFF}${BLACK} $git_branch \[$txtred\]\$git_dirty\[$txtrst\]${TWHITE}${TRIANGLE}${OFF} "

alias gitc-ammend="git commit --amend"
alias gitc-update-branches="git remote update origin --prune"
alias lsl="ls -l"
