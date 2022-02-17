{
  config,
  pkgs,
  lib,
  ...
}:
let
  my-env = {
    SSH_ASKPASS_REQUIRE = "prefer";
  };
in {
  services.gnome.gnome-keyring.enable = true;
  programs.ssh.startAgent = true;
  programs.ssh.agentTimeout = "3h";

  environment.variables = my-env;
  environment.sessionVariables = my-env;

  environment.systemPackages = [
    pkgs.gnome.seahorse
  ];
}
