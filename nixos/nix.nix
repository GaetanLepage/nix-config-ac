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

  age.secrets.ssh-private-key = {
    file = ../secrets/rsa-ssh-private-key.age;
    path = "/root/.ssh/id_rsa";
  };
  # TODO need identification on repo
  system.autoUpgrade = {
    enable = true;
    dates = "04:00";
    flake = "git+ssh://git@github.com/GaetanLepage/nix-config-ac.git";
    flags = [
      "--update-input"
      "nixpkgs"
      "--no-write-lock-file"
    ];
    allowReboot = false;
  };
}
