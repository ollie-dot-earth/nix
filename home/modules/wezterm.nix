{ pkgs, ... }:

{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = builtins.readFile ../../configs/wezterm.lua;
  };
}
