#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ENV
export EDITOR=nvim
export VISUAL=nvim

# ALIAS
alias ls='eza -lah --icons --group-directories-first --time-style=long-iso'
alias cat='bat'
alias grep='grep --color=auto'

PS1='[\u@\h \W]\$ '
