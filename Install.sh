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

# install aur pkg
# ---------------
function install_aur_pkgs {
  local pkgs=("$@")

  for pkg in "${pkgs[@]}"; do
    # check pkg in the system
    if yay -Q $pkg &>>log; then
      echo "[OK] The pkg: $pkg already is installed"
    else
      # install if missing
      if yay -S $pkg --noconfirm &>>log; then
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

# step two, install std code editor
# ---------------------------------
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

# receive question and return true or false
# -----------------------------------------
input_value() {
  local question=$1
  read -rp "$question" value

  case $value in
  "y" | "yes" | "YES" | "Yes")
    echo "1"
    ;;
  *)
    echo "0"
    ;;
  esac
  return
}

# pkgs (karakurt) optional
# ------------------------
install_personal_pkgs() {
  local optional=$1

  local pkgs=(
    "keepassxc"
  )

  local aur_pkgs=(
    "spotify"
  )

  if [[ $optional == 1 ]]; then
    install_pkgs "${pkgs[@]}"
    install_aur_pkgs "${aur_pkgs[@]}"
  fi

  return
}

# step three, install aur helper
# ------------------------------
install_aur_helper() {
  local yay_link="https://aur.archlinux.org/yay.git"

  if pacman -Q yay &>>log; then
    echo "[OK] yay already installed"
  else
    # clone rep
    if ls /tmp/yay &>>log; then
      echo "[OK] yay already clone"
    else
      if git clone $yay_link /tmp/yay &>>log; then
        echo "[OK] yay clone"
      else
        echo "[FAIL] yay clone"
      fi
    fi
    # build
    cd /tmp/yay
    if makepkg -si --noconfirm &>>log; then
      echo "[OK] yay build"
    else
      echo "[FAIL] yay build"
    fi
    cd - &>/dev/null
  fi
}

# step four, install aur std pks
# ------------------------------
function install_aur_std_pkgs {
  local pkgs=(
    # lockscreen
    "i3lock-color"
  )

  install_aur_pkgs "${pkgs[@]}"
  return
}

# pkgs (nvidia) optional
# ----------------------
install_nvidia_drivers() {
  local optional=$1

  local pkgs=(
    "linux-headers"
    "nvidia-dkms"
    "nvidia-utils"
    "lib32-nvidia-utils"
  )

  if [[ $optional == 1 ]]; then
    install_pkgs "${pkgs[@]}"
  fi

  return
}

function main {
  local personal_pkgs=$(input_value "Do you want install karakurt pks? (y/n): ")
  local nvidia_drivers=$(input_value "Do you want install nvidia drivers? (y/n): ")

  create_std_dirs
  install_std_pkgs
  install_lazyvim
  install_aur_helper
  install_aur_std_pkgs
  install_nvidia_drivers $nvidia_drivers
  install_personal_pkgs $personal_pkgs
  exit 0
}

main
