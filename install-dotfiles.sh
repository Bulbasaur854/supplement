#!/bin/bash
set -e

ORIGINAL_DIR=$(pwd)
REPO_URL="https://github.com/Bulbasaur854/dotfiles"
REPO_NAME="dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d%H%M%S)"
CONFIG_PATHS=(
  "$HOME/.config/backgrounds"
  "$HOME/.bashrc"
  "$HOME/.config/hypr/hyprlock.conf"
  "$HOME/.config/starship.toml"
)
PACKAGES=(
  "backgrounds"
  "bashrc"
  "hyprlock"
  "starship"
)

if ! pacman -Qi "stow" &> /dev/null 2>&1; then
  echo "Install stow first"
  exit 1
fi

cd $HOME

# Check if repo already exists on system
if [ -d "$REPO_NAME" ]; then
  echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
  git clone "$REPO_URL"
fi

# Check if the clone was successful
if [ $? -eq 0 ]; then
  echo "Backing up old configs"
  mkdir -p "$BACKUP_DIR"
  for path in "${CONFIG_PATHS[@]}"; do
    [ -e "$path" ] || continue
    mv "$path" "$BACKUP_DIR"/
  done

  echo "Stowing dotfiles"
  cd "$REPO_NAME"
  for package in "${PACKAGES[@]}"; do
    stow "$package"
  done
else
  echo "Failed to clone the repository"
  exit 1
fi
