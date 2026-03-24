{ pkgs, lib, ... }:
{
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
        { name = "giacomocavalieri/zsh_gleam_completions"; }
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
        zshConfigRest = lib.mkOrder 1100 (builtins.readFile ../../../configs/zshrc-append.zsh);
      in
      lib.mkMerge [
        zshConfigEarlyInit
        zshConfig
        zshConfigRest
      ];
  };

  home.file.".p10k.zsh".source = ../../../configs/.p10k.zsh;

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

  home.packages = with pkgs; [
    zsh-powerlevel10k
    eza
  ];

}
