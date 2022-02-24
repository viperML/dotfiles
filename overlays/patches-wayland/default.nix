final: prev: let
  inherit (prev) callPackage;
in {
  # wlroots = prev.wlroots.overrideAttrs (
  #   prevAttrs: {
  #     src = prev.fetchFromGitHub {
  #       owner = "danvd";
  #       repo = "wlroots-eglstreams";
  #       sha256 = "0m4x63wnh7jnr0i1nhs221c0d8diyf043hhx0spfja6bc549bdxr";
  #       rev = "f3282ab9b545db8e76452332be63e2fbe380f1e9";
  #     };
  #   }
  # );

  river = let
    riverSession = ''
      [Desktop Entry]
      Name=River
      Comment=An i3-compatible Wayland compositor
      Exec=river
      Type=Application
    '';
  in
    prev.river.overrideAttrs (prevAttrs: {
      # patches = (prev.patches or []) ++ [
      #   ./river-eglstreams.patch
      # ];
      postInstall = ''
        mkdir -p $out/share/wayland-sessions
        echo "${riverSession}" > $out/share/wayland-sessions/river.desktop
      '';
      passthru.providedSessions = ["river"];
    });
}
