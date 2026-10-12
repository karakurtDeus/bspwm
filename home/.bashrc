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

# UTILS
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"

  yazi "$@" --cwd-file="$tmp"

  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi

  rm -f -- "$tmp"
}

PS1='[\u@\h \W]\$ '
