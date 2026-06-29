#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
timestamp="$(date +%Y%m%d%H%M%S)"
vscode_user="$HOME/Library/Application Support/Code/User"

backup_path() {
  local path="$1"
  if [ -L "$path" ]; then
    rm "$path"
  elif [ -e "$path" ]; then
    mv "$path" "$path.backup.$timestamp"
  fi
}

mkdir -p "$HOME/.config"
backup_path "$HOME/.config/nvim"
ln -s "$repo_root/nvim" "$HOME/.config/nvim"

mkdir -p "$vscode_user"
backup_path "$vscode_user/settings.json"
backup_path "$vscode_user/keybindings.json"
backup_path "$vscode_user/snippets"
ln -s "$repo_root/vscode/User/settings.json" "$vscode_user/settings.json"
ln -s "$repo_root/vscode/User/keybindings.json" "$vscode_user/keybindings.json"
ln -s "$repo_root/vscode/User/snippets" "$vscode_user/snippets"
