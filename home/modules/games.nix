{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pandora-launcher
    r2modman
  ];
}
