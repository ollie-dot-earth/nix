{
  pkgs,
  hostname,
  stateVersion,
  inputs,
  ...
}:
{
  imports = [
    inputs.direnv-instant.homeModules.direnv-instant
    ./modules/development.nix
    ./modules/fonts.nix
    ./modules/shell.nix
  ]
  ++ [
    ./host-specific/${hostname}.nix
  ];

  home.username = "liv";
  home.homeDirectory = "/home/liv";
  home.stateVersion = stateVersion;

  home.packages = with pkgs; [
    coreutils
    git
  ];

  home.sessionVariables = {
    TERMINAL = "wezterm";
    PASSWORD_STORE_TYPE = "basic";
    ZED_ALLOW_EMULATED_GPU = 1;
    SHELL = "zsh";
  };
}
