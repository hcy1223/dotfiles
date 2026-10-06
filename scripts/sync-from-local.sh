#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
vscode_user="$HOME/Library/Application Support/Code/User"

same_path() {
  [ -e "$1" ] && [ -e "$2" ] && [ "$(realpath "$1")" = "$(realpath "$2")" ]
}

if ! same_path "$HOME/.config/nvim" "$repo_root/nvim"; then
  rsync -a --delete \
    --exclude='.git/' \
    --exclude='.nvimlog' \
    --exclude='nvim.log' \
    "$HOME/.config/nvim/" "$repo_root/nvim/"
fi

mkdir -p "$repo_root/vscode/User/snippets"

if ! same_path "$vscode_user/settings.json" "$repo_root/vscode/User/settings.json"; then
  rsync -a --delete "$vscode_user/settings.json" "$repo_root/vscode/User/settings.json"
fi

if ! same_path "$vscode_user/keybindings.json" "$repo_root/vscode/User/keybindings.json"; then
  rsync -a --delete "$vscode_user/keybindings.json" "$repo_root/vscode/User/keybindings.json"
fi

if ! same_path "$vscode_user/snippets" "$repo_root/vscode/User/snippets"; then
  rsync -a --delete "$vscode_user/snippets/" "$repo_root/vscode/User/snippets/"
fi

if command -v code >/dev/null 2>&1; then
  code --list-extensions > "$repo_root/vscode/extensions.txt"
fi

# Fish/Ghostty snapshots are managed manually. Review credentials before
# refreshing them; linking with install-to-local.sh avoids repeat imports.
