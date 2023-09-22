{pkgs, ...}: {
  systemd = {
    services.backup-home-to-server = {
      description = "Script that periodically backups the /home directory to /tank/backup/acl-desktop";

      serviceConfig = {
        Type = "oneshot";
        User = "anne-catherine";
      };
      script = ''
        # Do not crash the service if the rsync command fails
        set +e

        whoami

        # rsync backup command
        ${pkgs.rsync}/bin/rsync \
          -rav \
          --delete \
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
    };

    timers.backup-var-to-tank = {
      wantedBy = ["timers.target"];
      after = ["multi-user.target"];

      timerConfig = {
        OnCalendar = "hourly";
        Persistent = "yes";
      };
    };
  };
}
