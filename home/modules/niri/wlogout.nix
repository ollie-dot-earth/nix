{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "hyprlock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "niri msg action quit --skip-confirmation";
        text = "Logout";
        keybind = "e";
      }

      {
        label = "shutdown";
        action = "poweroff";
        text = "Shutdown";
        keybind = "s";
      }

      {
        label = "reboot";
        action = "reboot";
        text = "Reboot";
        keybind = "r";
      }

      {
        label = "hibernate";
        action = "niri msg action open-overview; niri msg action spawn -- hyprlock && systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }

      {
        label = "suspend";
        action = "niri msg action spawn -- hyprlock && systemctl suspend-then-hibernate";
        text = "Sleep";
        keybind = "z";
      }
    ];
    style = ''

      * {
        font-family: "Lotion Black", FontAwesome, Roboto, Helvetica, Arial, sans-serif;
      	background-image: none;
      	transition: 20ms;
      	box-shadow: none;
      }

      window {
      	background-color: rgba(12, 12, 12, 0.8);
      }

      button {
      	color: #FFFFFF;
        font-size:20px;
      	margin: 10px;
      	border-radius: 20px;
        background-repeat: no-repeat;
      	background-position: center;
      	background-size: 25%;
        background-color: unset;
      	border-style: solid;
      	border: 3px solid #FFFFFF;
        box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
      }

      #lock {
      	background-image: image(url("icons/lock.png"));
        background-color: #7facb3;
      }

      #logout {
      	background-image: image(url("icons/logout.png"));
        background-color: #ff4500;
      }

      #shutdown {
      	background-image: image(url("icons/shutdown.png"));
        background-color: #8b0000;
      }

      #reboot {
      	background-image: image(url("icons/reboot.png"));
        background-color: #556b2f;
      }

      #hibernate {
      	background-image: image(url("icons/hibernate.png"));
        background-color: #368cf9;
      }
      #suspend {
      	background-image: image(url("icons/suspend.png"));
        background-color: #f4d3a7;
      }

      button:focus,
      button:active,
      button:hover {
        color: #FFFFFF;
      	border: 3px solid #FFFFFF;
        background-color: #ffffff;
      }
    '';
  };

  xdg.configFile."wlogout/icons" = {
    source = ../../../configs/wlogout-icons;
    recursive = true;
  };
}
