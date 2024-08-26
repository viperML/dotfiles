{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [pkgs.pam_u2f pkgs.yubikey-manager pkgs.gnupg];

  security.pam.u2f = {
    enable = true;
    settings = {
      origin = "pam://${config.networking.hostName}";
      appId = "pam://${config.networking.hostName}";
      cue = true;
    };
  };
}
