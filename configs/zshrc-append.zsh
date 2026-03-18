# -------------------------------------------------------------------------------
# Proper functions and such go in here (.zshrc.append) for lsp support ----------
# -------------------------------------------------------------------------------


# Completion styling ------------------------------------------------------------
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Functions --------------------------------------------------------------------- 


# Alias function: dev
dev() {
    if [[ -n "$IN_NIX_SHELL" ]]; then
        echo "⚠️  Already inside Nix shell!"
        return 0
    fi

    if [[ -f .envrc ]]; then
        echo "⚠️  .envrc found, direnv will be used."
        direnv allow
        return 0
    fi

    if ! command -v nix >/dev/null 2>&1; then
        echo "󱄅  Nix is not installed!"
        return 0
    fi

    if ! [ -e flake.nix ]; then
        echo "❌ No flake.nix file in this directory"
        return 1
    fi

    nix develop --set-env-var SHELL "$SHELL" -c "$SHELL"
}


function create-envrc() {
    if [ -e .envrc ]; then
        echo "⚠️  .envrc already here, can't safely insert."
        return 0
    fi

    if ! command -v nix > /dev/null 2>&1; then 
        echo "󱄅  Nix is not installed!"
        return 1
    fi

    if ! command -v direnv > /dev/null 2>&1; then 
        echo "󱄅  Direnv is not installed!"
        return 1
    fi

    if ! [ -e flake.nix ]; then
        echo "❌ No flake.nix file in this directory"
        return 1
    fi

    if ! [ -e .gitignore ] || ! grep -q "^\.direnv/" .gitignore 
    then 
        echo "💨 Adding direnv cache to gitignore"
        echo -e "\n# Ignore direnv cache\n.direnv/" >> .gitignore
    fi

    echo "if nix flake show &> /dev/null; then
      use flake
    fi" >./.envrc

    direnv allow
}

_zap() {
    if ! [ -d .jj ] && ! [ -d .git ]; then
        eza -a --icons
        return 0
    fi

    clear -x
    local repo_type=""

    if [[ -d .git && -d .jj ]]; then
        repo_type="JJ (git-colocated)"
    elif [[ -d .jj ]]; then
        repo_type="Jujutsu"
    else
        repo_type="Git"
    fi

    echo "📂 Opened $repo_type repository: $(pwd)"

    if [[ -d .git ]]; then
        git fetch
    else
        jj git fetch
    fi

    # Show repository line counts (assuming 'kc' is another alias/function)
    kc

    if [[ -d .jj ]]; then
        jj log -Tbuiltin_log_compact_full_description -r'ancestors(bookmarks() & @-, 4) & ~@' --reversed --no-pager 
        jj show --summary
    else
        git status
    fi

    # Dynamically tell user of flakes.
    if [[ -f flake.nix ]] && command -v nix >/dev/null 2>&1 && [[ -z "$IN_NIX_SHELL" ]] && [[ ! -f .envrc ]]; then
            echo -e "\n\n❄️\tFound flake.nix, run 'create-envrc' to create a .envrc file here to load this flake automatically."
        echo -e "\tOr alternatively, run 'dev' to open Fish in a nix develop shell."
    fi
}


_zap_on_cd() {
    # Check if we are in an interactive shell to avoid
    # cluttering automated scripts
    [[ -t 1 ]] && _zap
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd _zap_on_cd

