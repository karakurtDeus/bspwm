#!/bin/bash

config_home=(
  "$HOME/.xinitrc"
  "$HOME/.bashrc"
)

config_dirs=(
  "$HOME/.config/bspwm"
  "$HOME/.config/sxhkd"
)

function copy() {
  sudo rm -R home config
  mkdir -p home config

  # copy files for $HOME
  for config in "${config_home[@]}"; do
    if cp -R $config home &>>log; then
      echo "[OK] $config copy in project"
    else
      echo "[FAIL] $config copy in project"
      exit 1
    fi
  done

  # copy config fipes for $HOME/.config
  for config in "${config_dirs[@]}"; do
    if cp -R $config config &>>log; then
      echo "[OK] $config copy in project"
    else
      echo "[FAIL] $config copy in project"
      exit 1
    fi
  done
  return
}

case "$1" in
--copy)
  copy
  ;;
*)
  echo "Use --copy to copy the configs into the project"
  echo "Use --update to update the configs in the project"
  ;;
esac
