final: prev: let callPackage = prev.callPackage; in {
  multiload-ng = callPackage ./multiload-ng { };
  papirus-icon-theme = callPackage ./papirus-icon-theme { papirus-icon-theme = prev.papirus-icon-theme; };
  netboot-xyz-images = callPackage ./netboot-xyz-images { };
  plasma-applet-splitdigitalclock = callPackage ./splitdigitalclock { };
  mohist-server = callPackage ./mohist-server { };
  disconnect-tracking-protection = callPackage ./disconnect-tracking-protection { };
  stevenblack-hosts = callPackage ./StevenBlack-hosts { };
  bdcompat = callPackage ./bdCompat { };
  vlmcsd = callPackage ./vlmcsd { };
  # kwin-forceblur = prev.libsForQt5.callPackage ./kwin-forceblur { };

  libsForQt5 = let callPackage = prev.libsForQt5.callPackage; in
    prev.libsForQt5 //
    {
      lightly = callPackage ./Lightly { };
      sierrabreezeenhanced = callPackage ./SierraBreezeEnhanced { };
      reversal-kde = callPackage ./Reversal-kde { };
      kwin-forceblur = callPackage ./kwin-forceblur { };
      koi-fork = callPackage ./Koi-fork { };
      plasma-theme-switcher = callPackage ./plasma-theme-switcher { };
    };
}
