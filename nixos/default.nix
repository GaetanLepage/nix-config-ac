{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware.nix

    ./agenix.nix
    ./backup.nix
    ./networking.nix
    ./nix.nix
    ./printer.nix
    ./security.nix
    ./server-tank-nfs.nix
    ./ssh.nix
    ./users.nix
    ./wireguard
    ./xorg.nix
  ];

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";

  console = {
    font = "Lat2-Terminus13";
    keyMap = "fr";
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # LVS (fwupd)
  services.fwupd.enable = true;

  boot = {
    # Silent boot
    consoleLogLevel = 0;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
    ];

    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 4;
      };
      grub.enable = false;

      timeout = 0;

      efi.canTouchEfiVariables = true;
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  environment.systemPackages = with pkgs; [
    btop
    ethtool
    htop
    ncdu
    tmux

    # GUI applications
    evince
    firefox
    gthumb
    libreoffice-fresh
    mission-center
    thunderbird
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
