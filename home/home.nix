{
  pkgs,
  hostname,
  ...
}:

{
  imports = [
    ./modules/development.nix
    ./modules/fonts.nix
    ./modules/games.nix
    ./modules/gnome.nix
    ./modules/librewolf.nix
    ./modules/niri.nix
    ./modules/shell.nix
    ./modules/wezterm.nix
  ]
  ++ [
    ./host-specific/${hostname}.nix
  ];

  home.username = "mar";
  home.homeDirectory = "/home/mar";
  home.stateVersion = "25.11"; # Ensure this matches your NixOS version

  home.packages = with pkgs; [
    coreutils
    # GUI Apps
    vivaldi
    #gnomeExtensions.gesture-improvements
    gnomeExtensions.appindicator
    git
  ];

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

  home.sessionVariables = {
    TERMINAL = "wezterm";
    PASSWORD_STORE_TYPE = "basic";
    ZED_ALLOW_EMULATED_GPU = 1;
    SHELL = "fish";
  };

  systemd.user.services.wallpaper-switcher = {
    Unit.Description = "Swap wallpaper based on time";
    Service = {
      ExecStart = pkgs.writeShellScript "swap-wall" ''
        if [ ! -d "/home/mar/.local/share/wallpapers/aesthetic-wallpapers" ]; then
          git clone https://github.com/D3Ext/aesthetic-wallpapers.git /home/mar/.local/share/wallpapers/aesthetic-wallpapers
        fi
        HOUR=$(date +%H)
        if [ $HOUR -ge 19 ] || [ $HOUR -lt 8 ]; then
          # Night time: 19:00 to 07:59
          ln -sf /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pastel-window.png /home/mar/.local/share/wallpapers/current_wallpaper.png
          noctalia-shell ipc call wallpaper set /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pastel-window.png ""
          noctalia-shell ipc call darkMode setDark
        else
            # Day time
          ln -sf /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pixel_big_city.png /home/mar/.local/share/wallpapers/current_wallpaper.png
          noctalia-shell ipc call wallpaper set /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pixel_big_city.png ""
          noctalia-shell ipc call darkMode setLight
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

}
