{
  pkgs,
  browser ? pkgs.microsoft-edge-beta,
  makeWrapper,
  symlinkJoin,
  lib,
}: let
  flags = [
    "--disable-features=UseChromeOSDirectVideoDecoder"
    "--enable-features=VaapiVideoEncoder,VaapiVideoDecoder,CanvasOopRasterization"
    "--ignore-gpu-blocklist"
    "--enable-gpu-rasterization"
    "--enable-accelerated-2d-canvas"
    "--enable-accelerated-video-decode"
    "--enable-zero-copy"
    "--ozone-platform-hint=x11"
    "--use-gl=desktop"
  ];
  exe = browser.meta.mainProgram or (lib.getName browser.name);
in
  (symlinkJoin {
    inherit (browser) name;
    paths = [browser];
    nativeBuildInputs = [makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/${exe} \
        --add-flags "${lib.concatStringsSep " " flags}"

      for f in $out/share/applications/*; do
        sed -i "s:/nix/store/.*/bin/.* :$out/bin/${exe} :" $f
        sed -i "s:/nix/store/.*/bin/[a-zA-Z-]*$:$out/bin/${exe}:" $f
      done
    '';
  })
  .overrideAttrs (prev: {
    __nocachix = true;
    pname = browser.pname or (lib.getName browser.name);
    version = browser.version or (lib.getVersion browser.name);
    inherit (browser) meta;
  })
