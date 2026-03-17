local get_time_of_day = function()
    local hour = tonumber(os.date("%H"))
    if hour >= 6 and hour < 12 then
        -- morning
        -- return "Rosé Pine Dawn (Gogh)" -- need to find a good light one
        return "Catppuccin Mocha"
    elseif hour >= 12 and hour < 18 then
        -- afternoon
        return "Catppuccin Mocha" -- need to find a good light one
    elseif hour >= 18 and hour < 24 then
        -- evening
        return "Catppuccin Mocha"
    else
        -- night
        return "Catppuccin Mocha"
    end
end

local wezterm = require('wezterm')
local config = {}

config.color_scheme = get_time_of_day()

-- config.color_scheme = "Catppuccin Mocha"

config.font = wezterm.font 'Maple Mono NF'
config.font_size = 16

config.window_padding = {
    left = 5,
    right = 5,
    top = 5,
    bottom = 5,
}

config.window_close_confirmation = 'NeverPrompt'


-- auto maximize on startup
local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
    if mux then
        local tab, pane, window = mux.spawn_window(cmd or {})
        window:gui_window():maximize()
    end
end)

-- and finally, return the configuration to wezterm
return config
