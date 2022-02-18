final: prev: let
  inherit (prev) callPackage;
in {
  multiload-ng = callPackage ./multiload-ng {};
  g-papirus-icon-theme = callPackage ./g-papirus-icon-theme { inherit (prev) papirus-icon-theme; };
  netboot-xyz-images = callPackage ./netboot-xyz-images {};
  plasma-applet-splitdigitalclock = callPackage ./plasma-applet-splitdigitalclock {};
  disconnect-tracking-protection = callPackage ./disconnect-tracking-protection {};
  stevenblack-hosts = callPackage ./stevenblack-hosts {};
  bdcompat = callPackage ./bdcompat {};
  vlmcsd = callPackage ./vlmcsd {};
  adwaita-plus = callPackage ./adwaita-plus {};
  tym = callPackage ./tym {};
  adw-gtk3 = callPackage ./adw-gtk3 {};

  libsForQt5 = prev.libsForQt5.overrideScope' (
    qtfinal: qtprev: let
      inherit (qtprev) callPackage;
    in rec {
      lightly = callPackage ./lightly {};
      sierrabreezeenhanced = callPackage ./sierrabreezeenhanced {};
      reversal-kde = callPackage ./reversal-kde {};
      kwin-forceblur = callPackage ./kwin-forceblur {};
      lightlyshaders = callPackage ./lightlyshaders { inherit (qtprev) kdelibs4support; };
    }
  );

  # gnomeExtensions = prev.gnomeExtensions.overrideScope' (
  #   gExtFinal: gExtPrev: {
  #     tidalwm = gExtPrev.callPackage ./tidalwm {};
  #   }
  # );
  gnomeExtensions =
    prev.gnomeExtensions
    // {
      tidalwm = callPackage ./tidalwm {};
    };
}
