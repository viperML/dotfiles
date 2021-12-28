{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ age sops ];

  # sops.defaultSopsFile = ../../secrets/main.yaml;
  sops.age.keyFile = "/secrets/age/keys.txt";
  sops.age.generateKey = true;

  # sops.secrets.multimc = {};

  # sops.secrets.msaClientID.sopsFile = ../../secrets/multimc.yaml;

  # sops.secrets."initialPassword/ayats".sopsFile = ../../secrets/users.yaml;
  # sops.secrets."initialPassword/ayats".neededForUsers = true;
}
