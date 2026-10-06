# Keep Homebrew environment parity with ~/.zprofile
if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
end

set -gx EDITOR "vim"
set -gx MOONSHOT_API_KEY "" # Supply privately after restore.

# Match useful zsh defaults from previous oh-my-zsh setup
set -gx PAGER "less"
set -gx LESS "-R"
set -gx LS_COLORS "di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
set -gx LSCOLORS "Gxfxcxdxbxegedabagacad"

if test -d "$HOME/.antigravity/antigravity/bin"
    fish_add_path -g -m "$HOME/.antigravity/antigravity/bin"
end

if test -d "$HOME/.local/bin"
    fish_add_path -g -m "$HOME/.local/bin"
end

if test -d "/Applications/Obsidian.app/Contents/MacOS"
    fish_add_path -g -m "/Applications/Obsidian.app/Contents/MacOS"
end
