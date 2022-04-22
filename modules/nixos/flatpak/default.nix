{
  config,
  pkgs,
  ...
}: {
  services.flatpak.enable = true;
  home-manager.sharedModules = [
    ./hm.nix
  ];
}
