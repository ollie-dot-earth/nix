{
  pkgs,
  lib,
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
        pkgs.gnomeExtensions."gsconnect".extensionUuid
      ];
    };
    "org/gnome/shell" = {
      favorite-apps = [ ];
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

    "org/gnome/shell/keybindings" = {
      show-screenshot-ui = [ (lib.hm.gvariant.mkString "<Shift><Super>s") ];
    };
    "org/gnome/desktop/wm/keybindings" = {
      close = [ (lib.hm.gvariant.mkString "<Super>q") ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "open-files";
      binding = lib.hm.gvariant.mkString "<Super>f";
      command = "nautilus";
    };

    "org/gnome/system/location".enabled = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # 'librewolf.desktop' or 'vivaldi-stable.desktop'
      "text/html" = "vivaldi-stable.desktop";
      "x-scheme-handler/http" = "vivaldi-stable.desktop";
      "x-scheme-handler/https" = "vivaldi-stable.desktop";
      "x-scheme-handler/about" = "vivaldi-stable.desktop";
      "x-scheme-handler/unknown" = "vivaldi-stable.desktop";
      "application/xhtml+xml" = "vivaldi-stable.desktop";
      "application/pdf" = "vivaldi-stable.desktop";
      "application/x-extension-htm" = "vivaldi-stable.desktop";
      "application/x-extension-html" = "vivaldi-stable.desktop";
      "application/x-extension-shtml" = "vivaldi-stable.desktop";
      "application/x-extension-xhtml" = "vivaldi-stable.desktop";
      "application/x-extension-xht" = "vivaldi-stable.desktop";
    };
  };

  systemd.user.services.wallpaper-switcher = {
    Unit.Description = "Swap wallpaper based on time";
    Service = {
      ExecStart = pkgs.writeShellScript "swap-wall" ''
        if [ ! -d "/home/liv/.local/share/wallpapers/aesthetic-wallpapers" ]; then
          git clone https://github.com/D3Ext/aesthetic-wallpapers.git /home/liv/.local/share/wallpapers/aesthetic-wallpapers
        fi
        HOUR=$(date +%H)
        if [ $HOUR -ge 19 ] || [ $HOUR -lt 8 ]; then
          # Night time: 19:00 to 07:59
          ln -sf /home/liv/.local/share/wallpapers/aesthetic-wallpapers/images/pastel-window.png /home/liv/.local/share/wallpapers/current_wallpaper.png
        else
            # Day time
          ln -sf /home/liv/.local/share/wallpapers/aesthetic-wallpapers/images/pixel_big_city.png /home/liv/.local/share/wallpapers/current_wallpaper.png
        fi
      '';
    };
  };

  # Run every hour
  systemd.user.timers.wallpaper-switcher = {
    Unit.Description = "Hourly wallpaper check";
    Timer = {
      OnCalendar = "hourly";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

  home.packages = with pkgs; [
    dconf-editor
    # gnomeExtensions.dash-to-dock
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.all-in-one-clipboard
    gnomeExtensions.search-light
    gnomeExtensions.gsconnect
    nautilus
    # GUI Apps
    vivaldi
    #gnomeExtensions.gesture-improvements
    gnomeExtensions.appindicator
  ];
}
