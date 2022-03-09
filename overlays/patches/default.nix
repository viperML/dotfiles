final: prev: let
  inherit (prev) callPackage fetchFromGitHub;
in {
  any-nix-shell = callPackage ./any-nix-shell {inherit (prev) any-nix-shell;};
  obsidian = callPackage ./obsidian {inherit (prev) obsidian;};

  python3 = prev.python3.override {
    packageOverrides = python3-final: python3-prev: {
      xlib = python3-prev.xlib.overrideAttrs (prevAttrs: {
        patches = [
          ./python-xlib-xauth-fix.patch
        ];
      });
    };
  };

  /*
   awesome = prev.awesome.overrideAttrs (_: {
   */
  /*
   version = "unstable-2022-03-06";
   */
  /*
   src = fetchFromGitHub {
   */
  /*
   owner = "awesomewm";
   */
  /*
   repo = "awesome";
   */
  /*
   rev = "392dbc21ab6bae98c5bab8db17b7fa7495b1e6a5";
   */
  /*
   sha256 = "093zapjm1z33sr7rp895kplw91qb8lq74qwc0x1ljz28xfsbp496";
   */
  /*
   };
   */
  /*
   });
   */
  /**/
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
