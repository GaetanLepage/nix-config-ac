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
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    agenix,
    agenix-rekey,
    devshell,
  } @ inputs: let
    hostname = "acl-desktop";
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = nixpkgs.lib.systems.flakeExposed;

      imports = [
        inputs.devshell.flakeModule
      ];

      flake = {
        agenix-rekey = agenix-rekey.configure {
          userFlake = self;
          nodes = self.nixosConfigurations;
        };

        nixosConfigurations = {
          ${hostname} = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./nixos
              agenix.nixosModules.default
              agenix-rekey.nixosModules.default
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
            agenix-rekey.packages.${system}.default
            pkgs.wol
          ];

          commands = [
            {
              name = "wake";
              command = "wol d8:9e:f3:12:76:04 -h feroe.glepage.com -p 9";
            }
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
