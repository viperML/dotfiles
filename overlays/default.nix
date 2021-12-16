final: prev: {

  sierrabreezeenhanced = prev.libsForQt5.callPackage ./SierraBreezeEnhanced { };
  lightly = prev.libsForQt5.callPackage ./Lightly { };

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

}
