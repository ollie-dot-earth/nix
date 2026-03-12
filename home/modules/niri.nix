{
  pkgs,
  inputs,
  config,
  ...
}:

{
  imports = [
    ./niri/noctalia.nix
    ./niri/hyprlock.nix
    ./niri/wlogout.nix

    inputs.niri.homeModules.niri

  ];

  home.packages = with pkgs; [
    wev
    kdePackages.krunner
    kdePackages.kdeconnect-kde
    kdePackages.qttools
    gnome-console
    gnome-keyring
    nautilus
    pavucontrol
    btop
    hyprlock
    libnotify
    xwayland-satellite
    wireplumber
    brightnessctl
    xclip
    wl-clipboard
    cliphist
    playerctl
    killall
    wvkbd
  ];
  xdg.configFile."niri/scripts/osk.sh" = {
    text = ''
      #!/run/current-system/sw/bin/bash
      # Relaunch the touch keyboard if it crashed

      PID=$(pidof wvkbd-mobintl)

      if [ -z "$PID" ]; then
        wvkbd-mobintl -L 300 --bg e06666 --fg f4cccc --fg-sp fa8071 --text 000000 --text-sp 000000 --press ff4d47 --press-sp ff0000 --alpha 200
      else
        echo $line >/dev/null
        # Its running, so send it a signal to toggle it up
        kill -34 "$PID"
      fi
    '';
    executable = true;
  };
  xdg.configFile."niri/scripts/overview-runner.sh" = {
    text = ''
      #!/run/current-system/sw/bin/bash
      overviewstatus="$(niri msg overview-state)"
      if [[ $overviewstatus == *"is close"* ]]; then
        niri msg action open-overview
      else
        niri msg action close-overview
        noctalia-shell ipc call launcher toggle
      fi
    '';
    executable = true;
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri;
    settings = {
      input = {
        keyboard = {
          xkb.layout = "us(altgr-intl)";
          numlock = false;
        };
        touchpad = {
          tap = true;
          natural-scroll = true;
          disabled-on-external-mouse = true;
        };
        mouse.accel-speed = 1.0;
        focus-follows-mouse.max-scroll-amount = "15%";
      };

      layer-rules = [
        {
          matches = [
            { namespace = "^noctalia-overview*"; }
          ];
          place-within-backdrop = true;
        }
      ];

      environment = {
        GTK_IM_MODULE = "ibus";
        QT_IM_MODULE = "ibus";
        XMODIFIERS = "@im=ibus";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
      };

      # samurott-nix's second screen is on the left.
      outputs."Virtual-2".position = {
        x = -30000;
        y = 0;
      };

      layout = {
        gaps = 15;
        center-focused-column = "never";
        always-center-single-column = true;

        preset-column-widths = [
          { proportion = 0.25; }
          { proportion = 0.5; }
          { proportion = 0.75; }
          { proportion = 1.0; }
        ];
        preset-window-heights = [
          { proportion = 0.4; }
          { proportion = 0.74; }
          { proportion = 1.0; }
        ];
        default-column-width.proportion = 0.75;
        focus-ring.enable = false;
        border = {
          enable = true;
          width = 6;
          active.color = "#85aaa0";
          inactive.color = "#4a4442";
          urgent.color = "#1e8b44";
        };
        shadow = {
          enable = true;
          softness = 30;
          spread = 5;
          offset = {
            x = 0;
            y = 5;
          };
          color = "#0007";
        };
        struts = {
          left = 14;
          right = 14;
        };
      };
      # Startup spawns!
      spawn-at-startup = [
        { command = [ "noctalia-shell" ]; }
        { command = [ "spotify" ]; }
        { command = [ "discord" ]; }
        { command = [ "teams-for-linux" ]; }
        { command = [ "thunderbird" ]; }
        {
          command = [
            "wl-paste"
            "--type"
            "text"
            "--watch"
            "cliphist"
            "store"
          ];
        }
        {
          command = [
            "wl-paste"
            "--type"
            "image"
            "--watch"
            "cliphist"
            "store"
          ];
        }
        {
          command = [
            "dbus-update-activation-environment"
            "--systemd"
            "DISPLAY"
            "WAYLAND_DISPLAY"
            "XDG_CURRENT_DESKTOP"
            "NIXOS_OZONE_WL"
          ];
        }
        {
          command = [
            "gnome-keyring-daemon"
            "--start"
            "--components=secrets"
          ];
        }
        { command = [ "kdeconnectd" ]; }
        { sh = "sleep 5s; niri msg action focus-workspace 1 && systemctl --user start wallpaper-switcher"; }
      ];

      prefer-no-csd = true;
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      workspaces = {
        # First three workspaces permanent and unnamed
        "1" = { };
        "2" = { };
        "3" = { };
        # Then two permanent dedicated ones
        "💬" = { };
        "🎧" = { };
      };

      window-rules = [
        {
          matches = [
            { app-id = "^org\\.wezfurlong\\.wezterm$"; }
            { app-id = "Spotify"; }
          ];

          open-maximized = true;
        }
        {
          matches = [ { title = "waybar"; } ];
          open-floating = true;
          default-column-width.proportion = 0.1;
        }
        {
          matches = [
            {
              app-id = "Chromium-browser";
              title = "(.*) • (.*)";
            }
            { title = "^Picture-in-Picture$"; }
            { app-id = "org.gnome.Characters"; }
            { app-id = "org.gnome.Calculator"; }
          ];
          open-floating = true;
        }
        {
          matches = [
            { app-id = "Spotify"; }
            { app-id = "org.gnome.Music"; }
          ];
          open-on-workspace = "🎧";
        }
        {
          matches = [
            { app-id = "discord"; }
            { app-id = "org.kde.kdeconnect.app"; }
            { app-id = "BeeperTexts"; }
            { app-id = "thunderbird"; }
            { app-id = "fluffychat"; }
            { app-id = "teams-for-linux"; }
          ];
          open-on-workspace = "💬";
        }
        {
          matches = [
            { app-id = "^org\\.keepassxc\\.KeePassXC$"; }
            { app-id = "^org\\.gnome\\.World\\.Secrets$"; }
          ];
          block-out-from = "screen-capture";
        }
        {
          # This rule applies to all windows as it has no 'matches'
          geometry-corner-radius = {
            bottom-left = 20.0;
            bottom-right = 20.0;
            top-left = 20.0;
            top-right = 20.0;
          };
          clip-to-geometry = true;
        }
      ];

      binds = {
        "Mod+Shift+Slash".action.show-hotkey-overlay = [ ];

        "Mod+Return" = {
          action.spawn = "wezterm";
          hotkey-overlay.title = "Open a Terminal: wezterm";
        };
        "Mod+Shift+Return" = {
          action.spawn = "kgx";
          hotkey-overlay.title = "Open a Terminal: Gnome Console";
        };
        "Mod+e" = {
          action.spawn = "nautilus";

          hotkey-overlay.title = "Open that gnome file browser";
        };
        "Mod+Shift+B" = {
          action.spawn = "librewolf";
          hotkey-overlay.title = "Open default browser: Librewolf";
        };
        "Mod+B" = {
          action.spawn = "vivaldi";
          hotkey-overlay.title = "Open browser: Vivaldi";
        };
        "Mod+D" = {
          action.spawn = [
            "noctalia-shell"
            "ipc"
            "call"
            "launcher"
            "toggle"
          ];
          hotkey-overlay.title = "Launcher";
        };
        "Mod+Shift+D" = {
          action.spawn = [ "krunner" ];
          hotkey-overlay.title = "Krunner";
        };
        "Alt+Space" = {
          action.spawn = [ "krunner" ];
          hotkey-overlay.title = "Krunner";
        };
        "Mod+V" = {
          action.spawn = [
            "noctalia-shell"
            "ipc"
            "call"
            "launcher"
            "clipboard"
          ];
          hotkey-overlay.title = "Clipboard";
        };
        "Mod+Period" = {
          action.spawn = [
            "noctalia-shell"
            "ipc"
            "call"
            "launcher"
            "emoji"
          ];
          hotkey-overlay.title = "Emoji";
        };

        # Audio media keys
        XF86AudioRaiseVolume = {
          action.spawn = [
            "wpctl"
            "set-volume"
            "@DEFAULT_AUDIO_SINK@"
            "0.02+"
          ];
          allow-when-locked = true;
        };
        XF86AudioLowerVolume = {
          action.spawn = [
            "wpctl"
            "set-volume"
            "@DEFAULT_AUDIO_SINK@"
            "0.02-"
          ];
          allow-when-locked = true;
        };

        XF86AudioMute = {
          action.spawn = [
            "wpctl"
            "set-mute"
            "@DEFAULT_AUDIO_SINK@"
            "toggle"
          ];
          allow-when-locked = true;
        };
        XF86AudioMicMute = {
          action.spawn = [
            "wpctl"
            "set-mute"
            "@DEFAULT_AUDIO_SOURCE@"
            "toggle"
          ];
          allow-when-locked = true;
        };

        # Other  media keys, brightness:
        XF86MonBrightnessDown = {
          allow-when-locked = true;
          action.spawn = [
            "brightnessctl"
            "set"
            "1%-"
          ];
        };
        XF86MonBrightnessUp = {
          allow-when-locked = true;
          action.spawn = [
            "brightnessctl"
            "set"
            "+1%"
          ];
        };
        # Next/previous track keys:
        XF86AudioNext = {
          allow-when-locked = true;
          action.spawn = [
            "playerctl"
            "next"
          ];
        };
        XF86AudioPrev = {
          allow-when-locked = true;
          action.spawn = [
            "playerctl"
            "previous"
          ];
        };
        XF86AudioPlay = {
          allow-when-locked = true;
          action.spawn = [
            "playerctl"
            "play-pause"
          ];
        };

        "Mod+O".action.toggle-overview = [ ];
        "Mod+Q".action.close-window = [ ];

        "Mod+Left".action.focus-column-left = [ ];
        "Mod+Down".action.focus-window-or-workspace-down = [ ];
        "Mod+Up".action.focus-window-or-workspace-up = [ ];
        "Mod+Right".action.focus-column-right = [ ];
        "Mod+Shift+Left".action.move-column-left = [ ];
        "Mod+Shift+Down".action.move-window-down-or-to-workspace-down = [ ];
        "Mod+Shift+Up".action.move-window-up-or-to-workspace-up = [ ];
        "Mod+Shift+Right".action.move-column-right = [ ];

        "Mod+Home".action.focus-column-first = [ ];
        "Mod+End".action.focus-column-last = [ ];
        "Mod+Ctrl+Home".action.move-column-to-first = [ ];
        "Mod+Ctrl+End".action.move-column-to-last = [ ];

        "Mod+Ctrl+Left".action.focus-monitor-left = [ ];
        "Mod+Ctrl+Down".action.focus-monitor-down = [ ];
        "Mod+Ctrl+Up".action.focus-monitor-up = [ ];
        "Mod+Ctrl+Right".action.focus-monitor-right = [ ];
        "Mod+Ctrl+H".action.focus-monitor-left = [ ];
        "Mod+Ctrl+J".action.focus-monitor-down = [ ];
        "Mod+Ctrl+K".action.focus-monitor-up = [ ];
        "Mod+Ctrl+L".action.focus-monitor-right = [ ];
        "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = [ ];
        "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = [ ];
        "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = [ ];
        "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = [ ];
        "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = [ ];
        "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = [ ];
        "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = [ ];
        "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = [ ];
        "Mod+Page_Down".action.focus-workspace-down = [ ];
        "Mod+Page_Up".action.focus-workspace-up = [ ];
        "Mod+U".action.focus-workspace-down = [ ];
        "Mod+I".action.focus-workspace-up = [ ];
        "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = [ ];
        "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = [ ];
        "Mod+Ctrl+U".action.move-column-to-workspace-down = [ ];
        "Mod+Ctrl+I".action.move-column-to-workspace-up = [ ];
        "Mod+Shift+Page_Down".action.move-workspace-down = [ ];
        "Mod+Shift+Page_Up".action.move-workspace-up = [ ];
        "Mod+Shift+U".action.move-workspace-down = [ ];
        "Mod+Shift+I".action.move-workspace-up = [ ];

        "Mod+WheelScrollRight" = {
          action.focus-column-right = [ ];
          cooldown-ms = 150;
        };
        "Mod+WheelScrollLeft" = {
          action.focus-column-left = [ ];
          cooldown-ms = 150;
        };
        "Mod+Ctrl+WheelScrollDown" = {
          action.move-column-to-workspace-down = [ ];
          cooldown-ms = 150;
        };
        "Mod+Ctrl+WheelScrollUp" = {
          action.move-column-to-workspace-up = [ ];
          cooldown-ms = 150;
        };
        "Mod+WheelScrollDown" = {
          action.focus-window-or-workspace-down = [ ];
          cooldown-ms = 150;
        };
        "Mod+WheelScrollUp" = {
          action.focus-window-or-workspace-up = [ ];
          cooldown-ms = 150;
        };
        "Mod+Shift+WheelScrollDown".action.focus-column-right = [ ];
        "Mod+Shift+WheelScrollUp".action.focus-column-left = [ ];
        "Mod+Ctrl+WheelScrollRight".action.move-column-right = [ ];
        "Mod+Ctrl+WheelScrollLeft".action.move-column-left = [ ];
        "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = [ ];
        "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = [ ];

        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;
        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Shift+5".action.move-column-to-workspace = 5;
        "Mod+Shift+6".action.move-column-to-workspace = 6;
        "Mod+Shift+7".action.move-column-to-workspace = 7;
        "Mod+Shift+8".action.move-column-to-workspace = 8;
        "Mod+Shift+9".action.move-column-to-workspace = 9;

        "Mod+BracketLeft".action.consume-or-expel-window-left = [ ];
        "Mod+BracketRight".action.consume-or-expel-window-right = [ ];
        "Mod+M".action.consume-window-into-column = [ ];
        "Mod+Comma".action.expel-window-from-column = [ ];
        "Mod+R".action.switch-preset-column-width = [ ];
        "Mod+Shift+R".action.switch-preset-window-height = [ ];

        # Half
        "Mod+H".action.set-column-width = "50%";
        # K: Dutch "kwart" (quarter), i.e. 25%
        "Mod+K".action.set-column-width = "25%";

        "Mod+Ctrl+R".action.reset-window-height = [ ];
        "Mod+F".action.maximize-column = [ ];
        "Alt+Return".action.fullscreen-window = [ ];

        # Expand the focused column to space not taken up by other fully visible columns.
        # Makes the column "fill the rest of the space".
        "Mod+Shift+F".action.expand-column-to-available-width = [ ];
        "Mod+C".action.center-column = [ ];
        # Center all fully visible columns on screen.
        "Mod+Ctrl+C".action.center-visible-columns = [ ];

        "Mod+Minus".action.set-column-width = "-5%";
        "Mod+Equal".action.set-column-width = "+5%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        "Mod+X".action.toggle-window-floating = [ ];
        "Mod+Shift+X".action.switch-focus-between-floating-and-tiling = [ ];
        "Mod+W".action.toggle-column-tabbed-display = [ ];

        "Super+Shift+S".action.screenshot = [ ];
        "Super+Ctrl+Shift+S".action.screenshot-screen = [ ];
        "Super+Alt+Shift+S".action.screenshot-window = [ ];
        "Print".action.screenshot = [ ];
        "Ctrl+Print".action.screenshot-screen = [ ];
        "Alt+Print".action.screenshot-window = [ ];

        "Mod+Escape" = {
          action.toggle-keyboard-shortcuts-inhibit = [ ];
          allow-inhibiting = false;
        };

        "Ctrl+Alt+Delete".action.spawn = "wlogout";
        "Super+L" = {
          action.spawn = [
            "sh"
            "-c"
            "niri msg action spawn -- hyprlock && niri msg action power-off-monitors"
          ];
          hotkey-overlay.title = "Lock the system";
        };
      };

      # --- Debug ---
      debug.honor-xdg-activation-with-invalid-serial = true;
    };
  };
}
