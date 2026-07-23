{
  description = "totally not mar's dotfiles for nix :3";

  inputs = {
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-26.05";
    };
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    direnv-instant.url = "github:Mic92/direnv-instant";

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
        hostname: system: stateVersion:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs hostname stateVersion; };
          modules = [
            {
              nixpkgs.overlays = [
                inputs.neovim-nightly-overlay.overlays.default
              ];
            }
            ./hosts/${hostname}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = { inherit inputs hostname stateVersion; };
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
        shitbox = mkSystem "shitbox" "x86_64-linux" "26.05";
        beeg-puter = mkSystem "beeg-puter" "x86_64-linux" "26.05";
      };
    };
}
