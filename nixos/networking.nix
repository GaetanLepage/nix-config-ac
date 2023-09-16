{
  networking = {
    hostName = "acl-desktop";

    # Pick only one of the below networking options.
    wireless.enable = false;
    networkmanager.enable = true;

    firewall.enable = true;
  };
}
