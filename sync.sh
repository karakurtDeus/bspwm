#!/bin/bash

# $HOME
config_home=(
  ".xinitrc"
  ".bashrc"
)

# $HOME/.config
config_dirs=(
  "bspwm"
  "sxhkd"
  "yazi"
  "kitty"
  "flameshot"
  "polybar"
)

function copy() {
  sudo rm -R home config
  mkdir -p home config

  # copy files for $HOME
  for config in "${config_home[@]}"; do
    if cp -R $HOME/$config home &>>log; then
      echo "[OK] $config copy in project"
    else
      echo "[FAIL] $config copy in project"
      exit 1
    fi
  done

  # copy config fipes for $HOME/.config
  for config in "${config_dirs[@]}"; do
    if cp -R $HOME/.config/$config config &>>log; then
      echo "[OK] $config copy in project"
    else
      echo "[FAIL] $config copy in project"
      exit 1
    fi
  done
  return
}

function update() {

  # replace config in $HOME
  for config in "${config_home[@]}"; do
    if rm -R $HOME/$config &>>log; then
      echo "[OK] $config delete old file"
    else
      echo "[FAIL] $config delete old file"
    fi

    if cp -R ./home/$config $HOME &>>log; then
      echo "[OK] $config update file"
    else
      echo "[FAIL] $config update file"
      exit 1
    fi
  done

  # replace config in $HOME/.config
  for config in "${config_dirs[@]}"; do
    if rm -R $HOME/.config/$config &>>log; then
      echo "[OK] $config delete old dir"
    else
      echo "[FAIL] $config delete old dir"
    fi

    if cp -R ./config/$config $HOME/.config &>>log; then
      echo "[OK] $config update dir"
    else
      echo "[FAIL] $config update dir"
      exit 1
    fi
  done

  return
}

case "$1" in
--copy)
  copy
  ;;
--update)
  update
  ;;
*)
  echo "Use --copy to copy the configs into the project"
  echo "Use --update to update the configs in the project"
  ;;
esac
