{
  nixpkgs.config.allowUnfree = true;

  # Enable flake support
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes

      warn-dirty = false
    '';

    # Garbage collection
    gc = {
      automatic = true;
      dates = "05:00";
      options = "--delete-older-than 4d";
    };
  };

  system.autoUpgrade = {
    enable = true;
    dates = "04:00";
    flake = "github:GaetanLepage/nix-config-ac";
    flags = [
      "--update-input"
      "nixpkgs"
      "--no-write-lock-file"
    ];
    allowReboot = false;
  };
}
