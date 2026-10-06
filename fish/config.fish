if status is-interactive
    alias vim "nvim"
    alias c "clear"
end

alias gst "git status"
alias gcam "git commit -m"

# ===== Java default version (for new fish shells, including many agents) =====
# 改成你想默认的版本：17 / 21 / 25
set -l __java_default_version 21

if test -x /usr/libexec/java_home
    set -gx JAVA_HOME (/usr/libexec/java_home -v $__java_default_version 2>/dev/null)
    if test -n "$JAVA_HOME"
        fish_add_path --move --prepend $JAVA_HOME/bin
    end
end

function jnow
    echo "JAVA_HOME=$JAVA_HOME"
    java -version
end

function juse
    if test (count $argv) -lt 1
        echo "Usage: juse <version>   e.g. juse 17"
        return 1
    end
    set -gx JAVA_HOME (/usr/libexec/java_home -v $argv[1] 2>/dev/null)
    if test -z "$JAVA_HOME"
        echo "No Java found for version $argv[1]"
        return 1
    end
    fish_add_path --move --prepend $JAVA_HOME/bin
    jnow
end

