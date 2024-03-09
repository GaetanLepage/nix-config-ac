{pkgs, ...}: {
  services = {
    printing = {
      enable = true;

      # All state directories relating to CUPS will be removed on startup of the service.
      stateless = true;
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
  };

  # hardware.printers = let
  #   printerName = "Brother_ACL";
  # in {
  #   ensureDefaultPrinter = printerName;
  #   ensurePrinters = [
  #     {
  #       name = printerName;
  #       location = "Bureau ACL";
  #       deviceUri = "ipp://192.168.1.20:631/ipp/print";
  #       model = "everywhere";
  #       ppdOptions = {
  #         PageSize = "A4";
  #       };
  #     }
  #   ];
  # };

  environment.systemPackages = with pkgs; [
    gnome.simple-scan
  ];
}
