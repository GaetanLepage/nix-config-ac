{pkgs, ...}: {
  services.xserver = {
    enable = true;

    # Configure keymap
    xkb.layout = "fr";

    displayManager = {
      lightdm = {
        enable = true;
        extraConfig = ''
          [Seat:*]
          greeter-setup-script=${pkgs.numlockx}/bin/numlockx on
        '';
      };
      defaultSession = "cinnamon";
    };

    desktopManager.cinnamon.enable = true;
  };

  # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };
}
