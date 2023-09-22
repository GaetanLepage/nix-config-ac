{pkgs, ...}: {
  environment.systemPackages = [pkgs.nfs-utils];

  services.autofs = {
    enable = true;

    autoMaster = let
      mapConf = pkgs.writeText "autofs.mnt" ''
        serveur-lepage \
            -fstype=nfs4 \
            10.10.10.2:/tank
      '';
    in ''
      /mnt        ${mapConf}          --timeout 60
    '';
  };
}
