local light_theme = "Breadog (Gogh)"
local dark_theme = "Catppuccin Mocha"

local wezterm = require('wezterm')

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local function get_appearance()
    if wezterm.gui then
        return wezterm.gui.get_appearance()
    end
    return 'Dark'
end

local function scheme_for_appearance(appearance)
    if appearance:find 'Light' then
        return light_theme
    else
        return dark_theme
    end
end

local config = {}

config.color_scheme = scheme_for_appearance(get_appearance())

config.font = wezterm.font 'Maple Mono NF'
config.font_size = 16

config.window_close_confirmation = 'NeverPrompt'

-- auto maximize on startup
local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
    if mux then
        local tab, pane, window = mux.spawn_window(cmd or {})
        -- mux_window
        window:gui_window():maximize()
    end
end)

-- layouts

wezterm.on("user-var-changed", function(window, pane, name, value)
    if name ~= "dev-layout" then return end

    local mux_window = window:mux_window()
    local tabs = mux_window:tabs()
    local tab_count = #(tabs)

    local spawn_commands_tab = function()
        local tab, _, _ = mux_window:spawn_tab {}
        tab:set_title "commands"
    end

    local spawn_client_tab = function()
        local tab, _, _ = mux_window:spawn_tab {
            args = { "zsh", "-ic", "direnv exec . just dev-client" }
        }
        tab:set_title "client"
    end

    local spawn_server_tab = function()
        local tab, _, _ = mux_window:spawn_tab {
            args = { "zsh", "-ic", "direnv exec . just dev-server" }
        }
        tab:set_title "server"
    end


    if tab_count == 1 then
        tabs[1]:set_title "neovim"
        spawn_commands_tab()
        spawn_client_tab()
        spawn_server_tab()
    elseif tab_count == 2 then
        tabs[1]:set_title "neovim"
        spawn_client_tab()
        spawn_server_tab()
    end

    if tab_count < 1 then return end
    tabs[1]:activate()
end)

wezterm.on("wait-for-direnv", function(pane, command)
    local info = pane:get_foreground_process_info()

    if info.status == "Sleep" then
        pane:send_text(command .. "\n")
    else
        wezterm.sleep_ms(100)
        wezterm.emit("wait-for-direnv", pane, command)
    end
end)

-- and finally, return the configuration to wezterm
return config
