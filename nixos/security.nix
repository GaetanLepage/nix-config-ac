{
  environment.shellAliases.sudo = "doas";

  security = {
    sudo.enable = false;
    doas.enable = true;
  };
}
