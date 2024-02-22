{
  users = {
    mutableUsers = false;

    users = let
      persoKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJSonNBBb1DlhaO4EfMh3TbIIsV25phZQ9vp/qKOw9E";
    in {
      root = {
        isSystemUser = true;

        hashedPassword = "$y$j9T$g3VikLdwJ80.kDQv8pAg50$vEH/nJvAlLcXRMDYHVO/pE96N98jihTLZbYYRXJGt7/";

        openssh.authorizedKeys.keys = [persoKey];
      };

      anne-catherine = {
        isNormalUser = true;

        # Need to be the same as on the server (for NFS permissions)
        uid = 1010;

        extraGroups = [
          "lepage"
          "wheel"
        ];

        # Enable ‘sudo’ for the user.
        # extraGroups = ["wheel"];

        hashedPassword = "$y$j9T$tjADhn4w1/QWR0j5FhhM7.$I7BV6eSTCm6uAnj58ylj5RnZBiKvzmy7u9AXu3TgqQA";

        openssh.authorizedKeys.keys = [persoKey];
      };
    };

    groups.lepage.gid = 1005;
  };

  # Members of group wheel can execute sudo commands without password.
  # security.sudo.wheelNeedsPassword = false;
}
