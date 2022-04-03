{ lib, pkgs, config, modulesPath, inputs, ... }:
let
  hn = "viperSL4";
in
{
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    inputs.nixos-wsl.nixosModules.wsl
  ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "nixos";
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker.enable = true;
    wslConf.network.hostname = hn;
  };

  networking.hostName = hn;
}
