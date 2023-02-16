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
      "desktop-kde"
    ])
    // {
      user-ayats = import ./users.nix {
        name = "ayats";
        uid = 1000;
      };
      user-soch = import ./users.nix {
        name = "soch";
        uid = 1001;
      };
    };
}
