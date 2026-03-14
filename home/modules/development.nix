{ pkgs, ... }:

{
  imports = [
    ./development/jujutsu.nix
    ./development/neovim.nix
    ./development/zed.nix
    ./development/vscodium.nix
  ];
  home.packages = with pkgs; [
    just
    just-lsp
    # I make a lot of things with Inkscape actually!
    inkscape
  ];
}
