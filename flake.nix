{
  description = "AC desktop NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    agenix,
  }: let
    hostname = "acl-desktop";
  in {
    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos
        agenix.nixosModules.default
      ];
    };

    apps = let
      system = "x86_64-linux";
    in {
      ${system}.default = {
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

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
