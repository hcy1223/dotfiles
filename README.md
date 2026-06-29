# Editor Dotfiles

This repository manages local Neovim and VS Code user configuration.

## Layout

- `nvim/` mirrors `~/.config/nvim`
- `vscode/User/settings.json` mirrors VS Code user settings
- `vscode/User/keybindings.json` mirrors VS Code keybindings
- `vscode/User/snippets/` mirrors VS Code user snippets
- `vscode/extensions.txt` records installed VS Code extensions

## Refresh From This Machine

```sh
./scripts/sync-from-local.sh
```

## Install To This Machine

```sh
./scripts/install-to-local.sh
```

The install script backs up existing local config paths before replacing them.

## Restore VS Code Extensions

```sh
xargs -n 1 code --install-extension < vscode/extensions.txt
```

