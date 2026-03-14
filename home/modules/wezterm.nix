{ pkgs, ... }:

{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
       local get_time_of_day = function()
      	local hour = tonumber(os.date("%H"))
      	if hour >= 6 and hour < 12 then
          -- morning
       		return "Rosé Pine Dawn (Gogh)"
      	elseif hour >= 12 and hour < 18 then
          -- afternoon
       		return "Rosé Pine Dawn (Gogh)"
      	elseif hour >= 18 and hour < 24 then
          -- evening
       		return "tokyonight_night"
      	else
          -- night
       		return "tokyonight_night"
      	end
       end

       local wezterm = require('wezterm')
       local config = {}

       -- config.color_scheme = get_time_of_day()

       config.color_scheme = "Catppuccin Mocha"

       config.font = wezterm.font 'Maple Mono NF'

       config.window_padding = {
          left = 5,
          right = 5,
          top = 5,
          bottom = 5,
       }

       config.window_close_confirmation = 'NeverPrompt'

       -- and finally, return the configuration to wezterm
       return config
    '';
  };
}
