final: prev: let
  inherit (prev) callPackage fetchFromGitHub;
in {
  # river = let
  #   riverSession = ''
  #     [Desktop Entry]
  #     Name=River
  #     Comment=An i3-compatible Wayland compositor
  #     Exec=river
  #     Type=Application
  #   '';
  # in
  #   prev.river.overrideAttrs (prevAttrs: rec {
  #     postInstall = ''
  #       mkdir -p $out/share/wayland-sessions
  #       echo "${riverSession}" > $out/share/wayland-sessions/river.desktop
  #     '';
  #     passthru.providedSessions = ["river"];
  #   });

  # Electron with vscode <1.64.X is broken in wayland (too old)
  # May be fixed in 1.65, who knows
  # - It wasn't fixed in 1.65
  vscode = prev.vscode.overrideAttrs (prevAttrs: {
    buildInputs = prevAttrs.buildInputs or [] ++ [prev.makeWrapper];
    postFixup =
      prevAttrs.postFixup
      or ""
      + ''
        wrapProgram $out/bin/code \
        --unset "WAYLAND_DISPLAY" \
        --unset "NIXOS_OZONE_WL"
      '';
  });
}
