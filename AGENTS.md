# Repository Guidelines

## Scope

This repository manages editor dotfiles for Neovim and VS Code.

Managed paths:

- `nvim/` mirrors Neovim config.
- `vscode/User/settings.json` mirrors VS Code user settings.
- `vscode/User/keybindings.json` mirrors VS Code keybindings.
- `vscode/User/snippets/` mirrors VS Code snippets.
- `vscode/extensions.txt` records installed VS Code extensions.

Do not add VS Code machine-local state such as `globalStorage`, `workspaceStorage`, `History`, `logs`, or `sync`.

## Scripts

- `scripts/install-to-local.sh` links this repository into local macOS/Linux config locations.
- `scripts/install-to-local.ps1` links this repository into local Windows config locations.
- `scripts/sync-from-local.sh` refreshes this repository from the local macOS config locations.

Run install or sync scripts only when the user asks for that action. They modify files outside the repository.

## Platform Paths

macOS/Linux:

- Neovim: `~/.config/nvim`
- VS Code: `~/Library/Application Support/Code/User`

Windows:

- Neovim: `%LOCALAPPDATA%\nvim`
- VS Code: `%APPDATA%\Code\User`

## Development Notes

- Keep changes small and focused.
- Preserve existing user edits in the working tree.
- Prefer symlinks for install scripts, matching the existing repository model.
- Keep scripts readable and dependency-light.
- Use ASCII in new files unless the file already uses another character set or the content requires it.

## Validation

For shell scripts:

```sh
bash -n scripts/install-to-local.sh
bash -n scripts/sync-from-local.sh
```

For PowerShell scripts, when PowerShell is available:

```powershell
pwsh -NoProfile -Command { $null = [scriptblock]::Create((Get-Content -Raw .\scripts\install-to-local.ps1)) }
```

Review the diff before finishing:

```sh
git diff
git status --short
```
