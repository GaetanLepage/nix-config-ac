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
    enable = false;
    dates = "04:00";
    flake = "https://github.com/GaetanLepage/nix-config-ac.git";
    flags = [
      "--update-input"
      "nixpkgs"
      "--no-write-lock-file"
    ];
    allowReboot = false;
  };
}
