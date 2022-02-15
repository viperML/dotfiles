final: prev: let
  inherit (prev) callPackage;
in
  {
    wlroots = prev.wlroots.overrideAttrs (
      prevAttrs: {
        src = prev.fetchFromGitHub {
          owner = "danvd";
          repo = "wlroots-eglstreams";
          sha256 = "0m4x63wnh7jnr0i1nhs221c0d8diyf043hhx0spfja6bc549bdxr";
          rev = "f3282ab9b545db8e76452332be63e2fbe380f1e9";
        };
      }
    );
    # vscode = prev.vscode.overrideAttrs (
    #   prevAttrs: {
    #     nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [ prev.makeWrapper ];
    #     postInstall =
    #       prevAttrs.postInstall or ""
    #       + ''
    #         wrapProgram $out/bin/code --unset WAYLAND_DISPLAY
    #       '';
    #   }
    # );
  }
