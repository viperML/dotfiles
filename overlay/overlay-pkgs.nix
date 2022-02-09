final: prev: let
  callPackage = prev.callPackage;
in
  {
    multiload-ng = callPackage ./multiload-ng { };
    papirus-icon-theme = callPackage ./papirus-icon-theme { inherit (prev) papirus-icon-theme; };
    netboot-xyz-images = callPackage ./netboot-xyz-images { };
    plasma-applet-splitdigitalclock = callPackage ./splitdigitalclock { };
    mohist-server = callPackage ./mohist-server { };
    disconnect-tracking-protection = callPackage ./disconnect-tracking-protection { };
    stevenblack-hosts = callPackage ./StevenBlack-hosts { };
    bdcompat = callPackage ./bdCompat { };
    vlmcsd = callPackage ./vlmcsd { };
    adwaita-plus = callPackage ./adwaita-plus { };

    libsForQt5 = prev.libsForQt5.overrideScope' (
      qtfinal: qtprev: let
        callPackage = qtprev.callPackage;
      in
        rec {
          lightly = callPackage ./Lightly { };
          sierrabreezeenhanced = callPackage ./SierraBreezeEnhanced { };
          reversal-kde = callPackage ./Reversal-kde { };
          kwin-forceblur = callPackage ./kwin-forceblur { };
          lightlyshaders = callPackage ./LightlyShaders { inherit (qtprev) kdelibs4support; };
          # koi-fork = callPackage ./Koi-fork { };
          # plasma-theme-switcher = callPackage ./plasma-theme-switcher { };
        }
    );
  }
