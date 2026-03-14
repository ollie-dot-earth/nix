{
  description = "totally not mar's dotfiles for nix :3";

  inputs = {
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-25.11";
    };
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";

    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      # Helper function to create system configs easily
      mkSystem =
        hostname: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs hostname; };
          modules = [
            inputs.noctalia.nixosModules.default
            ./hosts/${hostname}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = { inherit inputs hostname; };
              home-manager.users.liv = {
                imports = [
                  ./home/home.nix
                ];
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        shitbox = mkSystem "shitbox" "x86_64-linux";
      };
    };
}
