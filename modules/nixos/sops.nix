{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ age sops ];

  sops.defaultSopsFile = ../../secrets/test.yaml;
  sops.age.keyFile = "/home/ayats/.config/sops/age/keys.txt";

  sops.secrets.msaClientID.sopsFile = ../../secrets/multimc.yaml;

  sops.secrets."initialPassword/ayats".sopsFile = ../../secrets/users.yaml;
  sops.secrets."initialPassword/ayats".neededForUsers = true;
}
