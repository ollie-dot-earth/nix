{ pkgs, ... }:

{
  imports = [
    ./shell/kc.nix
  ];
  programs.zsh = {
    enable = true;
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

  xdg.configFile.".zshrc" = {
    source = ../../configs/.zshrc;
  };
  xdg.configFile.".p10k.zsh" = {
    source = ../../configs/.p10k.zsh;
  };
  home.packages = with pkgs; [
    eza
    bat
    zoxide
    zinit
    hyfetch
    macchina
    fzf
    xsel
    jq
    btop
  ];
}
