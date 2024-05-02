{
  lib,
  packages,
  pkgs,
  ...
}: {
  security.polkit = {
    extraConfig = lib.fileContents ./polkit.js;
    debug = true;
  };

  system.replaceRuntimeDependencies = [
    {
      original = pkgs.polkit;
      replacement = packages.self.polkit;
    }
  ];
}
