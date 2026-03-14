{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    font-awesome
    maple-mono.NF
    hermit
    nerd-fonts.lilex
    nerd-fonts.symbols-only
    font-awesome
    (runCommand "lotion-fonts" { } ''
      mkdir -p $out/share/fonts/truetype/lotion
      cp -r ${../../fonts/Lotion}/*.ttf $out/share/fonts/truetype/lotion/
    '')

    (runCommand "suse-font" { } ''
      mkdir -p $out/share/fonts/truetype/suse
      cp -r ${../../fonts/SUSE}/*.ttf $out/share/fonts/truetype/suse/
    '')
  ];
}
