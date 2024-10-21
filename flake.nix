{
  description = "NixOS configuration for multiple hosts";

  # Define inputs
  inputs = {
    # Use the latest NixOS unstable channel as your package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Import the impermanence module from the nix-community repository
    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      # url = "github:nix-community/home-manager/release-24.05";

      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs dependencies.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


    outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    impermanence,
    ...
  }: {
    nixosConfigurations = {
      desktop = let
        username = "rama";
        specialArgs = {inherit username;};
      in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";

          modules = [
            impermanence.nixosModules.impermanence
            ./hosts/desktop/impermanence.nix
            
            ./hosts/desktop/default.nix
            ./hosts/desktop/hardware-configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} = import ./users/${username}/home.nix;
            }
          ];
        };
    };
  };
}
