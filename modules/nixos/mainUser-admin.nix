{ config, pkgs, ... }:

{
  users.users.mainUser = {
    name = "admin";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "1234";
  };

  security.sudo.wheelNeedsPassword = false;

  nix.trustedUsers = [ "@wheel" ]; # https://github.com/serokell/deploy-rs/issues/25

  services.openssh = { enable = true; };
}
