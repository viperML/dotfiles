final: prev: {

  sierrabreezeenhanced = prev.libsForQt5.callPackage ./SierraBreezeEnhanced { };
  lightly = prev.libsForQt5.callPackage ./Lightly { };
  multiload-ng = prev.callPackage ./multiload-ng { };
  any-nix-shell = prev.callPackage ./any-nix-shell { any-nix-shell = prev.any-nix-shell; };
  papirus-icon-theme = prev.callPackage ./papirus-icon-theme { papirus-icon-theme = prev.papirus-icon-theme; };
  netboot-xyz-images = prev.callPackage ./netboot-xyz-images { };

  element-for-poor-people = with prev; makeDesktopItem {
    name = "Element";
    desktopName = "Element";
    genericName = "Secure and independent communication, connected via Matrix";
    exec = "${brave}/bin/brave --app=\"https://app.element.io/#/home\"";
    icon = "element";
    type = "Application";
    categories = "Network;InstantMessaging;";
    terminal = "false";
  };

  spotify-for-poor-people = with prev; makeDesktopItem {
    name = "Spotify Web";
    desktopName = "Spotify Web";
    genericName = "Music player";
    exec = "${brave}/bin/brave --app=\"https://open.spotify.com/\"";
    icon = "spotify";
    type = "Application";
    categories = "Audio;AudioVideo;Music";
    terminal = "false";
  };

  word-for-poor-people = with prev; makeDesktopItem {
    name = "Word";
    desktopName = "Word";
    genericName = "ms-word";
    exec = "${brave}/bin/brave --app=\"https://www.office.com/launch/word\"";
    icon = "ms-word";
    type = "Application";
    categories = "Office";
    terminal = "false";
  };

  excel-for-poor-people = with prev; makeDesktopItem {
    name = "Excel";
    desktopName = "Excel";
    genericName = "ms-word";
    exec = "${brave}/bin/brave --app=\"https://www.office.com/launch/excel\"";
    icon = "ms-excel";
    type = "Application";
    categories = "Office";
    terminal = "false";
  };
}
