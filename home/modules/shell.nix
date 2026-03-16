{ pkgs, lib, ... }:

{
  imports = [
    ./shell/kc.nix
  ];
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
        rb = "doas nixos-rebuild switch --flake ~/.dotfiles#$(hostname)";
        ls = "ls --color";
    };
    history = {
        size = 5000;
        append = true;
        share = true;
        ignoreSpace = true;
        ignoreAllDups = true;
        saveNoDups = true;
        findNoDups = true;
    };

    zplug = {
        enable = true;
        plugins = [
            { name = "zsh-users/zsh-syntax-highlighting"; }
            { name = "zsh-users/zsh-completions"; }
            { name = "zsh-users/zsh-autosuggestions"; }
            { name = "Aloxaf/fzf-tab"; }
        ];
    };
    initContent = let 
    zshConfigEarlyInit = lib.mkOrder 500 ''
        if [[ -r "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
    ''; 
    zshConfig = lib.mkOrder 1000 ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        # Completion styling
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
    ''; 
    in lib.mkMerge [ zshConfigEarlyInit zshConfig ];
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
        auto_sync = true;
        sync_frequency = "5m";
        sync_address = "https://atuin.nuv.sh";
    };
  };

  programs.direnv = {
    silent = true;
    enable = true;
  };

  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "sapphic";
      mode = "rgb";
      light_dark = "light";
      lightness = 1.0;
      color_align = {
        mode = "horizontal";
      };
      backend = "macchina";
      pride_month_disable = false;
    };

  };

  xdg.configFile."powerlevel10k/p10k.zsh".source = ../../configs/.p10k.zsh;

  home.packages = with pkgs; [
    zsh-powerlevel10k
    eza
    bat
    hyfetch
    macchina
    xsel
    jq
    btop
  ];
}
