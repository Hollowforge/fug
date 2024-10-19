{
  description = "NixOS configuration for multiple hosts";

  # Define inputs
  inputs = {
    # Use the latest NixOS unstable channel as your package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Import the impermanence module from the nix-community repository
    impermanence.url = "github:nix-community/impermanence";
  };

  # Define outputs
  outputs = { self, nixpkgs, impermanence }: {
    nixosConfigurations = {
      # Define a desktop configuration for NixOS
      desktop = nixpkgs.lib.nixosSystem {
        # Target system architecture
        system = "x86_64-linux";

        # Import modules for this host's configuration
        modules = [
          impermanence.nixosModules.impermanence
          ./configuration.nix                # Your main NixOS configuration
          ./hardware-configuration.nix        # Import hardware configuration
          ./impermanence.nix                  # Import your impermanence-specific settings
        ];
      };
    };
  };
}
