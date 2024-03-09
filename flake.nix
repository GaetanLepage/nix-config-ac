{
  description = "AC desktop NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    devshell,
    agenix,
  } @ inputs: let
    hostname = "acl-desktop";
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = nixpkgs.lib.systems.flakeExposed;

      imports = [
        inputs.devshell.flakeModule
      ];

      flake = {
        nixosConfigurations = {
          ${hostname} = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./nixos
              agenix.nixosModules.default
            ];
          };
        };
      };

      perSystem = {
        config,
        pkgs,
        system,
        ...
      }: {
        formatter = pkgs.alejandra;

        devshells.default = {
          packages = [
            # agenix-rekey.packages.${system}.default
          ];

          commands = [
            {
              name = "deploy";
              command = ''
                echo "=> Updating system"
                nixos-rebuild switch \
                    --verbose \
                    --fast \
                    --flake .#${hostname} \
                    --target-host root@${hostname} \
                    --build-host root@${hostname}
              '';
            }
            {
              name = "update";
              command = ''
                echo "=> Updating flake inputs"
                nix flake update

                deploy
              '';
            }
          ];
        };
      };
    };
}
