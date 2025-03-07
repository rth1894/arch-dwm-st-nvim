#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='eza'
alias ll='eza -l --color=auto'
alias grep='grep --color=auto'
alias nf='selected=$(rg --files --hidden | fzf --preview "bat {} --color=always" --bind "ctrl-h:toggle-preview") && [ -n "$selected" ] && nvim "$selected"'
PS1='[\u@\h \W]\$ '
export PATH=$PATH:/usr/lib/jvm/java-23-openjdk/bin
