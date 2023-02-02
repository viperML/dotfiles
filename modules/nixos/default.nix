{
  lib,
  config,
  ...
}: {
  flake.nixosModules =
    (config.flake.lib.importFilesToAttrs ./. [
      "desktop-awesome"
      "desktop-gnome"
      "desktop-sway"
      "desktop"
      "docker"
      "flatpak"
      "hardware-amd"
      "ld"
      "podman"
      "printing"
      "virt"
      "xdg-ninja"
    ])
    // {
      user-ayats = import ./users.nix {
        name = "ayats";
        uid = 1000;
      };
    };
}
