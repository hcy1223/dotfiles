if command -q zoxide
    zoxide init fish | source
end

if command -q fnm
    set -l fnm_state_root "$HOME/.local/state"
    if test -d $fnm_state_root; and test -w $fnm_state_root
        fnm env --use-on-cd --shell fish | source
    end
end

if command -q starship
    starship init fish | source
end
