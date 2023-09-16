{pkgs, ...}: {
  services.xserver = {
    enable = true;

    # Configure keymap
    layout = "fr";

    # Gnome
    displayManager = {
      gdm = {
        enable = true;
        autoSuspend = false;
        # wayland = true;
      };
      # Force wayland session by default
      defaultSession = "cinnamon";
      # autoLogin = {
      #   enable = true;
      #   user = "acl";
      # };
    };

    desktopManager.cinnamon.enable = true;
  };

  # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };
}
