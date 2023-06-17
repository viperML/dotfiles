{
  lib,
  config,
  ...
}: {
  home.file =
    lib.genAttrs [
      "Documents"
      "Desktop"
      "Downloads"
      "Music"
      "Pictures"
      "Videos"
    ] (folder: {
      source = config.lib.file.mkOutOfStoreSymlink "/mnt/c/Users/${config.home.username}/${folder}";
    });

  nix.settings = import ../../misc/nix-conf-privileged.nix;
}
