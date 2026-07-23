{ pkgs, lib, ... }:

{
  imports = [
    ./shell/kc.nix
    ./shell/zsh.nix
  ];

  # TODO: add starship

  programs = {
    direnv = {
      silent = true;
      enable = true;
      nix-direnv.enable = true;
    };
    direnv-instant = {
      enable = true;
      enableZshIntegration = true;
    };
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

  home.file.".ssh/config".source = ../../configs/ssh-config;

  home.packages = with pkgs; [
    bat
    hyfetch
    macchina
    xsel
    jq
    btop
  ];
}
