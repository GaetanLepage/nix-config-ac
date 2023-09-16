{
  description = "AC desktop NixOS configuration";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    hostname = "acl-desktop";
  in {
    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [./nixos];
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
                --target-host root@gaming \
                --build-host root@gaming
          '');
      };
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
