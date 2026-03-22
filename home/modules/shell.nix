{ pkgs, lib, ... }:

{
  imports = [
    ./shell/kc.nix
  ];
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd zox" ];
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
      to-dotfiles = "cd ~/.dotfiles || cd ~/dotfiles";
      rb = "to-dotfiles && jj file track . && doas nixos-rebuild switch --flake ~/.dotfiles#$(hostname)";

      # totally didnt steal these from mar 👀
      ls = "eza --icons";
      la = "eza --icons -a";
      ll = "eza --icons -al";
      lt = "eza --icons -a --tree --level=1";
      v = "$EDITOR";
      cat = "bat -p";
      nano = "nvim";

      cd = "zox";
      cdi = "zoxi";
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
        { name = "anatolykopyl/doas-zsh-plugin"; }
      ];
    };
    initContent =
      let
        zshConfigEarlyInit = lib.mkOrder 500 ''
          hyfetch
          if [[ -r "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
              source "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi
        '';
        zshConfig = lib.mkOrder 1000 ''
          # p10k --------------------------------------------------------------------------
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        '';
        # more complex zsh functions n such go in here since i dont wanna deal with writing those without proper lsp
        zshConfigRest = lib.mkOrder 1100 (builtins.readFile ../../configs/zshrc-append.zsh);
      in
      lib.mkMerge [
        zshConfigEarlyInit
        zshConfig
        zshConfigRest
      ];
  };

  # TODO: ssh-config

  # TODO: add starship

  # TODO: actually log in n such
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

  home.file.".p10k.zsh".source = ../../configs/.p10k.zsh;
  home.file.".ssh/config".source = ../../configs/ssh-config;

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
