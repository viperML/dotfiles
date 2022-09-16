{
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.step-cli
  ];

  home.file =
    lib.genAttrs [
      "Documents"
      "Desktop"
      "Downloads"
      "Music"
      "Pictures"
      "Videos"
    ] (folder: {
      source = config.lib.file.mkOutOfStoreSymlink "/mnt/c/Users/ayats/${folder}";
    });

  # xdg.configFile."nix/rc".text = ''
  #   eval "$(${lib.getExe pkgs.direnv} hook bash)"
  #   # ${lib.getExe pkgs.keychain} -q --nogui
  #   . $HOME/.keychain/$(hostname)-sh
  #   ${lib.concatStringsSep "\n" (__attrValues (__mapAttrs (n: v: "export ${n}=${v}") config.home.sessionVariables))}
  # '';
}
