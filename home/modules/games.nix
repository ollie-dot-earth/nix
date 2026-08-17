{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pandora-launcher
    prismlauncher
    jdk25
    openjdk25

    r2modman
  ];
}
