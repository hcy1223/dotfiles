#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
timestamp="$(date +%Y%m%d%H%M%S)"
vscode_user="$HOME/Library/Application Support/Code/User"

backup_path() {
  local path="$1"
  if [ -e "$path" ]; then
    mv "$path" "$path.backup.$timestamp"
  fi
}

mkdir -p "$HOME/.config"
backup_path "$HOME/.config/nvim"
rsync -a "$repo_root/nvim/" "$HOME/.config/nvim/"

mkdir -p "$vscode_user"
backup_path "$vscode_user/settings.json"
backup_path "$vscode_user/keybindings.json"
backup_path "$vscode_user/snippets"
rsync -a "$repo_root/vscode/User/settings.json" "$vscode_user/settings.json"
rsync -a "$repo_root/vscode/User/keybindings.json" "$vscode_user/keybindings.json"
rsync -a "$repo_root/vscode/User/snippets/" "$vscode_user/snippets/"

