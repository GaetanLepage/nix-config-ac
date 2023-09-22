{
  fileSystems = let
    fsType = "nfs";
    options = [
      "noauto"
      "x-systemd.automount"
      "nfsvers=4"

      # disconnects after 10 minutes (i.e. 600 seconds)
      "x-systemd.idle-timeout=600"
    ];
  in {
    "/mnt/server" = {
      device = "10.10.10.1:/tank";
      inherit options fsType;
    };
  };
}
