{ config, pkgs, ... }:

{
  users.users.mainUser = {
    name = "admin";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "1234";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIBZkBer8ozZ/6u7AQ1FHXiF1MbetEUKZoV5xN5YkhMo ayatsfer@gmail.com"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  nix.trustedUsers = [ "@wheel" ]; # https://github.com/serokell/deploy-rs/issues/25

  services.openssh = { enable = true; };
  services.avahi.nssmdns = true;
}
