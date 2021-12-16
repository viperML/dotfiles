final: prev: {

  SierraBreezeEnhanced = prev.callPackage ./SierraBreezeEnhanced { };

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
}
