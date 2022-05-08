{pkgs, ...}: {
  boot.initrd.systemd = {
    enable = true;
    initrdBin = with pkgs; [
      (symlinkJoin {
        inherit (bash) name meta;
        paths = [bash];
        nativeBuildInputs = [makeWrapper];
        postBuild = ''
          ln -s $out/bin/bash $out/bin/sh
        '';
      })
    ];
  };
}
