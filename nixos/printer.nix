{pkgs, ...}: {
  services = {
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns = true;
    };
  };

  environment.systemPackages = with pkgs; [
    gnome.simple-scan
  ];
}
