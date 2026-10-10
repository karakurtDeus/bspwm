#!/bin/bash

# install pacman pkg
# ------------------
function install_pkgs {
  local pkgs=("$@")

  for pkg in "${pkgs[@]}"; do
    # check pkg in the system
    if sudo pacman -Q $pkg &>>log; then
      echo "[OK] The pkg: $pkg already is installed"
    else
      # install if missing
      if sudo pacman -S $pkg --noconfirm &>>log; then
        echo "[OK] The pkg: $pkg is installed"
      else
        # exit if fail installation
        echo "[FAIL] The pkg: $pkg installation error"
        exit 1
      fi
    fi
  done
  return
}

# step zero, create basic dirs
# ----------------------------
function create_std_dirs {
  local dirs=(
    # public dirs
    "Projects"
    "Downloads"
    "Music"
    "Videos"
    "Documents"
    "Pictures"

    # config dirs
    ".config"
    ".local"
    ".ssh"
  )

  for dir in ${dirs[@]}; do
    mkdir -p $HOME/$dir
  done
}

# step one, install basic pkgs
# -----------------------------
function install_std_pkgs {
  local pkgs=(
    # fonts
    "noto-fonts"
    "noto-fonts-cjk"
    "noto-fonts-emoji"
    "ttf-dejavu"
    "ttf-liberation"
    "ttf-font-awesome"
    "ttf-jetbrains-mono-nerd"
    "ttf-font-awesome"
    "ttf-nerd-fonts-symbols"

    # editor and other programming tools
    "nvim"
    "vim"
    "git"
    "base-devel"

    # terminal
    "kitty"
    "less"
    "bat"
    "eza"
    "yazi"

    # launcher
    "rofi"

    # browser
    "firefox"

    # network and other
    "openssh"

    # wm dep
    "xorg-server"
    "xorg-xinit"
    "bspwm"
    "sxhkd"
  )

  install_pkgs "${pkgs[@]}"
  return
}

install_lazyvim() {
  lazyvim_link="https://github.com/LazyVim/starter"
  lazyvim_dir="$HOME/.config/nvim"
  if ls $lazyvim_dir &>>log; then
    echo "[OK] Lazyvim already is installed"
  else
    if git clone $lazyvim_link $lazyvim_dir &>>log; then
      echo "[OK] Lazyvim is installed"
    else
      echo "[FAIL] Lazyvim installation error"
      exit 1
    fi
  fi
  return
}

function main {
  create_std_dirs
  install_std_pkgs
  install_lazyvim
  return
}

main
