{
  description = "AC desktop NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
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
    agenix,
  } @ inputs: let
    hostname = "acl-desktop";
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = nixpkgs.lib.systems.flakeExposed;

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

        apps.default = {
          type = "app";
          program = let
            pkgs = import nixpkgs {inherit system;};
          in
            toString (pkgs.writeShellScript "generate" ''
              echo "=> Updating flake inputs"
              nix flake update

              echo "=> Updating system"
              nixos-rebuild switch \
                  --verbose \
                  --fast \
                  --flake .#${hostname} \
                  --target-host root@${hostname} \
                  --build-host root@${hostname}
            '');
        };
      };
    };
}
