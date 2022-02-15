final: prev: let
  inherit (prev) callPackage;
in
  {
    any-nix-shell = callPackage ./any-nix-shell { inherit (prev) any-nix-shell; };
    obsidian = callPackage ./obsidian { inherit (prev) obsidian; };
    # discord = callPackage ./discord { inherit (prev) discord; };

    python3 = prev.python3.override {
      packageOverrides = python3-final: python3-prev: {
        xlib = python3-prev.xlib.overrideAttrs (
          prevAttrs: {
            patches = [
              ./python3/xlib/xauth-fix.patch
            ];
          }
        );
        # https://github.com/NixOS/nixpkgs/issues/159522
        remarshal = python3-prev.remarshal.overrideAttrs (
          prevAtrrs: {
            postPatch = ''
              substituteInPlace pyproject.toml \
                --replace "poetry.masonry.api" "poetry.core.masonry.api" \
                --replace 'PyYAML = "^5.3"' 'PyYAML = "*"' \
                --replace 'tomlkit = "^0.7"' 'tomlkit = "*"'
            '';
          }
        );
      };
    };

    # https://github.com/NixOS/nixpkgs/pull/156305
    spice = prev.spice.overrideAttrs (
      prevAttrs: {
        postPatch =
          prevAttrs.postPatch
          + ''
            # https://gitlab.freedesktop.org/spice/spice-common/-/issues/5
            substituteInPlace subprojects/spice-common/meson.build \
              --replace \
              "cmd = run_command(python, '-m', module)" \
              "cmd = run_command(python, '-c', 'import @0@'.format(module))"
          '';
      }
    );

    # https://github.com/NixOS/nixpkgs/issues/159270
    # https://github.com/NixOS/nixpkgs/pull/159340
    spice-gtk = callPackage ./spice-gtk { };

    # ryujinx = callPackage ./ryujinx { };

    # element-for-poor-people = with prev; makeDesktopItem {
    #   name = "Element";
    #   desktopName = "Element";
    #   genericName = "Secure and independent communication, connected via Matrix";
    #   exec = "${brave}/bin/brave --app=\"https://app.element.io/#/home\"";
    #   icon = "element";
    #   type = "Application";
    #   categories = "Network;InstantMessaging;";
    #   terminal = "false";
    # };

    # spotify-for-poor-people = with prev; makeDesktopItem {
    #   name = "Spotify Web";
    #   desktopName = "Spotify Web";
    #   genericName = "Music player";
    #   exec = "${brave}/bin/brave --app=\"https://open.spotify.com/\"";
    #   icon = "spotify";
    #   type = "Application";
    #   categories = "Audio;AudioVideo;Music";
    #   terminal = "false";
    # };

    # word-for-poor-people = with prev; makeDesktopItem {
    #   name = "Word";
    #   desktopName = "Word";
    #   genericName = "ms-word";
    #   exec = "${brave}/bin/brave --app=\"https://www.office.com/launch/word\"";
    #   icon = "ms-word";
    #   type = "Application";
    #   categories = "Office";
    #   terminal = "false";
    # };

    # excel-for-poor-people = with prev; makeDesktopItem {
    #   name = "Excel";
    #   desktopName = "Excel";
    #   genericName = "ms-word";
    #   exec = "${brave}/bin/brave --app=\"https://www.office.com/launch/excel\"";
    #   icon = "ms-excel";
    #   type = "Application";
    #   categories = "Office";
    #   terminal = "false";
    # };
  }
