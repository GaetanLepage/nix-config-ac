{
  fileSystems = {
    "/mnt/server" = {
      device = "10.10.10.1:/tank";
      fsType = "nfs";
      options = [
        "noauto"
        "x-systemd.automount"
        "nfsvers=4"

        # disconnects after 1 minute (i.e. 60 seconds)
        "x-systemd.idle-timeout=60"
        "x-systemd.mount-timeout=10"
      ];
    };
  };
}
