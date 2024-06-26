{
  pkgs,
  lib,
  ...
}: {
  systemd = let
    serviceName = "backup-home-to-server";
  in {
    services.${serviceName} = {
      description = "Script that periodically backups the /home directory to /tank/backup/acl-desktop";

      serviceConfig = {
        Type = "oneshot";
        User = "anne-catherine";
        ExecStart = lib.getExe (pkgs.writeShellApplication {
          name = "backup";
          runtimeInputs = with pkgs; [
            rsync
          ];
          text = ''
            # Do not crash the service if the rsync command fails
            set +e

            # rsync backup command
            rsync \
              -zravut \
              --human-readable \
              --delete \
              --delete-excluded \
              --exclude ".cache/" \
              /home \
              /mnt/server/lepage_family/backup/ac_desktop/

            # Collect rsync exit code
            status=$?

            case $status in
                # Catch exit code 24 as this error is not important
                0|24) exit 0 ;;

                # In case of an error other than 24, crash the service
                *) exit 1 ;;
            esac
          '';
        });
      };
    };

    timers.${serviceName} = {
      wantedBy = ["timers.target"];
      after = ["multi-user.target"];

      timerConfig = {
        OnCalendar = "hourly";
        Persistent = "yes";
      };
    };
  };
}
