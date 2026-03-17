{
  pkgs,
  lib,
  hostname,
  ...
}:

{
  dconf.settings = {
    "org/gnome/desktop/applications/browser" = {
      exec = "vivaldi-stable";
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        pkgs.gnomeExtensions."appindicator".extensionUuid
        # pkgs.gnomeExtensions."dash-to-dock".extensionUuid
        pkgs.gnomeExtensions."night-theme-switcher".extensionUuid
        pkgs.gnomeExtensions."blur-my-shell".extensionUuid
        pkgs.gnomeExtensions."search-light".extensionUuid
        pkgs.gnomeExtensions."all-in-one-clipboard".extensionUuid
      ];
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file:///home/liv/.local/share/wallpapers/aesthetic-wallpapers/images/pink-clouds.png";
      picture-uri-dark = "file:///home/liv/.local/share/wallpapers/aesthetic-wallpapers/images/wallhaven-9mjw78.png";
      picture-options = "zoom"; # "zoom", "centered", "scaled", etc.
    };
    "org/gnome/desktop/screensaver" = {
      picture-uri = "file:///home/liv/.local/share/wallpapers/aesthetic-wallpapers/images/wallhaven-9mjw78.png";
    };
    "org/gnome/desktop/interface" = {
      # color-scheme = "prefer-light"; # Handled by daynight plugin
      enable-hot-corners = false;
      show-battery-percentage = true;
    };
    "org/gnome/settings-daemon/plugins/orientation" = {
      active = true;
    };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-schedule-automatic = true;
    };
    "org/gnome/shell/extensions/nightthemeswitcher/time" = {
      nightthemeswitcher-ondemand-keybinding = [
        (lib.hm.gvariant.mkString "<Shift><Super>t")
      ];
    };
    "org/gnome/system/location".enabled = true;
  };
  home.packages = with pkgs; [
    dconf-editor
    # gnomeExtensions.dash-to-dock
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.all-in-one-clipboard
    gnomeExtensions.search-light
  ];
}
