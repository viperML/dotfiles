{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ age sops ];

  sops.defaultSopsFile = ../../secrets/test.yaml;
  sops.age.keyFile = "/home/ayats/.config/sops/age/keys.txt";

  sops.secrets.msaClientID.sopsFile = ../../secrets/multimc.yaml;
}
