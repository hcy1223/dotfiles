#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
vscode_user="$HOME/Library/Application Support/Code/User"

rsync -a --delete \
  --exclude='.git/' \
  --exclude='.nvimlog' \
  --exclude='nvim.log' \
  "$HOME/.config/nvim/" "$repo_root/nvim/"

mkdir -p "$repo_root/vscode/User/snippets"
rsync -a --delete "$vscode_user/settings.json" "$repo_root/vscode/User/settings.json"
rsync -a --delete "$vscode_user/keybindings.json" "$repo_root/vscode/User/keybindings.json"
rsync -a --delete "$vscode_user/snippets/" "$repo_root/vscode/User/snippets/"

if command -v code >/dev/null 2>&1; then
  code --list-extensions > "$repo_root/vscode/extensions.txt"
fi

