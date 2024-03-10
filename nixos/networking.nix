{
  pkgs,
  lib,
  ...
}: {
  networking = {
    hostName = "acl-desktop";

    # Pick only one of the below networking options.
    wireless.enable = false;
    networkmanager.enable = true;

    firewall.enable = true;
  };

  systemd.services.wakeonlan = {
    description = "Reenable wake on lan every boot";
    after = ["network.target"];
    serviceConfig = {
      Type = "simple";
      # RemainAfterExit = "true";
      RemainAfterExit = true;
      ExecStart = "${lib.getExe pkgs.ethtool} -s enp1s0 wol g";
    };
    wantedBy = ["default.target"];
  };
}
