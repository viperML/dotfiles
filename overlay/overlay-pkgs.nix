final: prev: {
  sierrabreezeenhanced = prev.libsForQt5.callPackage ./SierraBreezeEnhanced { };
  lightly = prev.libsForQt5.callPackage ./Lightly { };
  multiload-ng = prev.callPackage ./multiload-ng { };
  papirus-icon-theme = prev.callPackage ./papirus-icon-theme { papirus-icon-theme = prev.papirus-icon-theme; };
  netboot-xyz-images = prev.callPackage ./netboot-xyz-images { };
  plasma-applet-splitdigitalclock = prev.callPackage ./splitdigitalclock { };
  mohist-server = prev.callPackage ./mohist-server { };
  reversal-kde = prev.libsForQt5.callPackage ./Reversal-kde { };
  disconnect-tracking-protection = prev.callPackage ./disconnect-tracking-protection { };
  stevenblack-hosts = prev.callPackage ./StevenBlack-hosts { };
}
