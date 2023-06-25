{
  pkgs,
  packages,
  ...
}: {
  services.envfs.enable = true;

  programs.nix-ld = {
    enable = true;
    package = packages.nix-ld.default;
    libraries = with pkgs; [
      stdenv.cc.cc
      openssl
      curl
      glib
      util-linux
      icu
      libunwind
      libuuid
      zlib
      libsecret
    ];
  };
}
