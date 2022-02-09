final: prev: let
  callPackage = prev.callPackage;
in
  {
    any-nix-shell = callPackage ./any-nix-shell { inherit (prev) any-nix-shell; };
    g-kitty = callPackage ./g-kitty { };
    obsidian = callPackage ./obsidian { inherit (prev) obsidian; };

    python3 = prev.python3.override {
      packageOverrides = python3-final: python3-prev: {
        xlib = python3-prev.xlib.overrideAttrs (
          prevAttrs: {
            patches = [
              ./python3/xlib/xauth-fix.patch
            ];
          }
        );
      };
    };

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
