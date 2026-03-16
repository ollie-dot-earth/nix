{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fluffychat
    # Until I set up bridging between discord and @mar:strawmelonjuice.com
    vesktop
    telegram-desktop
  ];
}
