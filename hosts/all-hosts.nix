{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}:
{
  home-manager.backupFileExtension = "backup";

  nixpkgs.overlays = [
    (final: prev: {
      inherit (prev.lixPackageSets.stable)
        nixpkgs-review
        nix-eval-jobs
        nix-fast-build
        colmena
        ;
    })
  ];

  nix.package = pkgs.lixPackageSets.stable.lix;

  nixpkgs.config = {
    permittedInsecurePackages = [
    ];

    allowUnfree = true;
    packageOverrides = pkgs: {
      stable = import <nixpkgs-stable> {
        config = config.nixpkgs.config;
      };
    };
  };
  environment.variables = {
    GTK_IM_MODULE = lib.mkForce null;
    QT_IM_MODULE = lib.mkForce null;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.systemPackages = with pkgs; [
    git
    jj
    podman-compose
    podman-tui
    polkit_gnome
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
    gcc
  ];

  services.tailscale.enable = true;

  # Enable zsh
  programs.zsh.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment, Niri and KDE. I like to be able to switch whenever.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  # services.desktopManager.plasma6.enable = true;
  programs.ssh.askPassword = lib.mkForce "${pkgs.gnome-themes-extra}/libexec/seahorse/ssh-askpass";
  programs.niri.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.liv.enableGnomeKeyring = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.settings.auto-optimise-store = true;

  # User account
  users.users.liv = {
    isNormalUser = true;
    description = "ollie";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      thunderbird
      obsidian
    ];
  };
  security.pam.services.hyprlock = { };
  security.doas.enable = true;
  security.sudo.enable = false;
  security.doas.extraRules = [
    {
      users = [ "liv" ];
      keepEnv = true;
      noPass = true;
    }
  ];
}
