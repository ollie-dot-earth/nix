{ pkgs, ... }:

{
  home.packages = with pkgs; [
    prismlauncher
    r2modman
  ];
}
