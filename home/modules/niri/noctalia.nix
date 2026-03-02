{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  config = {
    home.packages = [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.rbw
      pkgs.curl
      pkgs.wtype
      pkgs.pinentry-tty
    ];

    services.gnome-keyring = {
      enable = true;
      components = [
        "pkcs11"
        "secrets"
        "ssh"
      ];
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      config.common.default = [ "gnome" ];
    };
    programs.noctalia-shell = {
      enable = true;
      systemd.enable = false;
      settings = {
        wallpaper = {
          enabled = true;
          overviewEnabled = true;
          path = "/home/mar/.local/share/wallpapers/current_wallpaper.png";
        };
        bar = {
          position = "top";
          margins = {
            top = 10;
            left = 15;
            right = 15;
          };
          capsuleOpacity = 1;
          backgroundOpacity = 0.3;
          useSeparateOpacity = true;
          floating = true;
          density = "default";
          widgets = {
            left = [
              {
                id = "CustomButton";
                icon = "square-arrow-up";
                leftClickExec = "bash -c '/home/mar/.config/niri/scripts/overview-runner.sh'";
                generalTooltipText = "Toggle overview, double-tap to toggle runner.";
                showIcon = true;
              }
              {
                id = "Workspace";
                showApplications = true;
                pillSize = 0.6;
                labelMode = "name";
                showLabelsOnlyWhenOccupied = true;
                characterCount = 5;
                hideUnoccupied = true;
                iconScale = 0.8;
              }
              {
                id = "ActiveWindow";
                maxWidth = 260;
                showIcon = false;
              }
            ];
            center = [
              {
                id = "plugin:catwalk";
              }
              {
                id = "Clock";
                formatHorizontal = "HH:mm\\ndddd, MMMM dd";
                formatVertical = "HH:mm";
                tooltipFormat = "";
              }
              {
                id = "NotificationHistory";
                showUnreadBadge = false;
                hideWhenZeroUnread = false;
              }
              {
                id = "plugin:kde-connect";
              }
            ];
            right = [
              {
                id = "Tray";
              }

              {
                id = "MediaMini";
              }
              {
                id = "CustomButton";
                icon = "keyboard";
                leftClickExec = "bash -c '/home/mar/.config/niri/scripts/osk.sh'";
                generalTooltipText = "Toggle the on-screen keyboard (restarts the keyboard if needed.)";
                showIcon = true;
              }
              {
                id = "Spacer";
              }
              {
                id = "Volume";
              }
              {
                id = "Brightness";
              }
              {
                id = "NightLight";
              }
              {
                id = "Spacer";
              }
              {
                alwaysShowPercentage = false;
                id = "Battery";
                warningThreshold = 30;
                displayMode = "graphic";
                showPowerProfiles = true;
                showNoctaliaPerformance = true;
              }
              {
                id = "Network";
              }
              {
                id = "Bluetooth";
              }
              {
                id = "Spacer";
              }
              {
                id = "LockKeys";
                hideWhenOff = true;
              }
              {
                id = "CustomButton";
                icon = "power";
                leftClickExec = "wlogout";
                generalTooltipText = "Power off options";
                showIcon = true;
              }
            ];
          };
        };
        controlCenter.enabled = false;
        dock.enabled = false;
        appLauncher = {
          enableClipboardHistory = true;
        };
        notifications = {
          enabled = true;
          enableMarkdown = true;
          density = "default";
          monitors = [ ];
          location = "top_center";
          overlayLayer = true;
          backgroundOpacity = 1;
          respectExpireTimeout = false;
          lowUrgencyDuration = 3;
          normalUrgencyDuration = 8;
          criticalUrgencyDuration = 15;
          clearDismissed = true;
          saveToHistory = {
            low = true;
            normal = true;
            critical = true;
          };
          enableMediaToast = false;
          enableKeyboardLayoutToast = true;
          enableBatteryToast = true;
        };
        osd = {
          enabled = true;
          location = "top_center";
          autoHideMs = 2000;
          overlayLayer = true;
          backgroundOpacity = 1;
          enabledTypes = [
            0
            1
            2
          ];
          monitors = [ ];
        };
        ui = {
          fontDefault = "Atkinson Hyperlegible Next 12";

        };
        location = {
          name = "Eindhoven";
          weatherEnabled = true;
          weatherShowEffects = true;
          useFahrenheit = false;
          use12hourFormat = false;
          showWeekNumberInCalendar = false;
          showCalendarEvents = true;
          showCalendarWeather = true;
          analogClockInCalendar = false;
          firstDayOfWeek = -1;
          hideWeatherTimezone = false;
          hideWeatherCityName = false;
        };
        nightLight = {
          enabled = true;
          forced = false;
          autoSchedule = true;
          nightTemp = "4000";
          dayTemp = "6500";
          manualSunrise = "08:00";
          manualSunset = "19:00";
        };
        colorSchemes.useWallpaperColors = false;
        colorSchemes.predefinedScheme = "Noctalia (default)";
        templates = {
          gtk = true;
          qt = true;
          niri = true;
        };
        sessionMenu = {
          enable = false;
        };
        plugins = {
          autoUpdate = true;
        };

      };
      pluginSettings = {
        catwalk = {
          minimumThreshold = 25;
          hideBackground = true;
        };
      };
      plugins = {

        sources = [
          {
            enabled = true;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
          {
            enabled = true;
            name = "Rukh Debug unofficial noctalia plugin repository";
            url = "https://github.com/rukh-debug/noctalia-unofficial-plugins";
          }
        ];
        states = {
          catwalk = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
          kde-connect = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
          niri-overview-launcher = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
          bitwarden-rbw-noctalia-launcher = {
            enabled = true;
            sourceUrl = "https://github.com/rukh-debug/noctalia-unofficial-plugins";

          };
        };
        version = 2;
      };

    };

    home.activation.setupNoctaliaDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p ${config.xdg.configHome}/gtk-4.0
      mkdir -p ${config.xdg.configHome}/gtk-3.0
      touch ${config.xdg.configHome}/gtk-4.0/gtk.css
      touch ${config.xdg.configHome}/gtk-3.0/gtk.css
    '';
    xdg.configFile."noctalia/colors.json".text = builtins.toJSON {
      "mSurface" = "#f1c4c7";
      "mOnSurface" = "#4a4442";
      "mPrimary" = "#1e8b44";
      "mOnPrimary" = "#e9c5c5";
      "mSecondary" = "#bfa399";
      "mOutline" = "#8c7b75";

      "mSurfaceVariant" = "#85aaa0";
      "mOnSurfaceVariant" = "#4a4442";
      "mTertiary" = "#e8a0a5";
      "mOnTertiary" = "#d0aeae";
      "mError" = "#cf6679";
      "mOnError" = "#ffffff";
      "mShadow" = "#000000";
      "mHover" = "#88bfae";
      "mOnHover" = "#ffffff";
    };
  };

}
