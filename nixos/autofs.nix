{pkgs, ...}: {
  environment.systemPackages = [pkgs.nfs-utils];

  services.autofs = {
    enable = true;

    autoMaster = let
      mapConf = pkgs.writeText "autofs.mnt" ''
        movies \
            -fstype=nfs4 \
            192.168.1.2:/tank/share/movies
      '';
    in ''
      /mnt        ${mapConf}          --timeout 60
    '';
  };
}
