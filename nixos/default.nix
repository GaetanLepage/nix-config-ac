{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware.nix

    ./autofs.nix
    ./networking.nix
    ./nix.nix
    ./security.nix
    ./ssh.nix
    ./users.nix
    ./xorg.nix
  ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus13";
    keyMap = "fr";
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # LVS (fwupd)
  services.fwupd.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 4;
    };
    grub.enable = false;

    timeout = 0;

    efi.canTouchEfiVariables = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    htop
    btop

    # GUI applications
    firefox
    signal-desktop
    vlc
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
