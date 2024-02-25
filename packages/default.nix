{ self
, inputs
, lib
, ...
}:
let
  /*
    wrapperFor returns a wrapper w for a set of pkgs

    wrapper incudes automatic overrides for a callPackage definition
  */
  wrapperFor = _pkgs: _callPackage: path: extraOverrides:
    let
      # args :: set
      args = builtins.functionArgs (import path);

      usesNvfetcher = builtins.hasAttr "src" args || builtins.hasAttr "sources" args;

      sources = _pkgs.callPackages (path + "/generated.nix") { };

      firstSource = builtins.head (builtins.attrValues sources);

      nvfetcherOverrides =
        if ! usesNvfetcher
        then { }
        else if builtins.hasAttr "sources" args
        then { inherit sources; }
        else builtins.intersectAttrs args firstSource;
    in
    _callPackage path (nvfetcherOverrides // extraOverrides);
in
{
  flake.overlays = {
    nix-version = final: prev: {
      nix =
        let
          targetVersion = "2.14.0";
          old = prev.nix;
          new = inputs.nix.packages.${final.system}.default;
        in
        if lib.versionAtLeast old.version targetVersion
        then builtins.trace "${old.name} reached desired version ${targetVersion}" old
        else new;
    };
  };

  perSystem =
    { pkgs
    , system
    , config
    , inputs'
    , ...
    }:
    let
      w = wrapperFor pkgs;
    in
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          self.overlays.nix-version
          inputs.nvfetcher.overlays.default
          inputs.emacs-overlay.overlays.default
        ];
      };

      checks = {
        nix = pkgs.nix;
        nh = inputs'.nh.packages.default;

        inherit
          (config.packages)
          adw-gtk3
          iosevka
          nix-index
          tailscale-systray
          wl-clip-persist
          xdg-ninja
          ;
      };

      legacyPackages = pkgs;

      packages = {
        # Main
        adw-gtk3 = w pkgs.callPackage ./main/adw-gtk3 { };
        colloid = w pkgs.callPackage ./main/colloid { };
        plasma-applet-splitdigitalclock = w pkgs.callPackage ./main/plasma-applet-splitdigitalclock { };
        present = w pkgs.callPackage ./main/present { };
        tailscale-systray = w pkgs.callPackage ./main/tailscale-systray { };
        toml-fmt = w pkgs.callPackage ./main/toml-fmt { };
        vlmcsd = w pkgs.callPackage ./main/vlmcsd { };
        xdg-ninja = w pkgs.callPackage ./main/xdg-ninja { };
        iosevka = w pkgs.callPackage ./main/iosevka { };
        clipmon = w pkgs.callPackage ./main/clipmon { };
        wl-clip-persist = w pkgs.callPackage ./main/wl-clip-persist { };
        multiload-ng = w pkgs.callPackage ./main/multiload-ng { };
        warp = w pkgs.callPackage ./main/warp {};
        elf-info = w pkgs.callPackage ./main/elf-info { };

        # Qt5
        kwin-forceblur = w pkgs.libsForQt5.callPackage ./qt5/kwin-forceblur { };
        lightly = w pkgs.libsForQt5.callPackage ./qt5/lightly { };
        reversal-kde = w pkgs.libsForQt5.callPackage ./qt5/reversal-kde { };
        sierrabreezeenhanced = w pkgs.libsForQt5.callPackage ./qt5/sierrabreezeenhanced { };

        # Fonts
        comic-code = w pkgs.callPackage ./fonts/comic-code { };
        hoefler-text = w pkgs.callPackage ./fonts/hoefler-text { };
        redaction = w pkgs.callPackage ./fonts/redaction { };
        san-francisco = w pkgs.callPackage ./fonts/san-francisco { };

        # Overrides
        nix-index = w pkgs.callPackage ./overrides/nix-index {
          database = inputs.nix-index-database.legacyPackages."x86_64-linux".database;
          databaseDate = self.lib.mkDate inputs.nix-index-database.lastModifiedDate;
        };
        any-nix-shell = w pkgs.callPackage ./overrides/any-nix-shell { };
        obsidian = w pkgs.callPackage ./overrides/obsidian { };
        papirus-icon-theme = w pkgs.callPackage ./overrides/papirus-icon-theme { };
        polkit = w pkgs.callPackage ./overrides/polkit { };

        sway-custom = pkgs.sway.override {
          sway-unwrapped = pkgs.sway-unwrapped.overrideAttrs (old: {
            inherit (pkgs.swayfx) src pname version meta patches;
          });
          extraSessionCommands = ''
            source /etc/profile
          '';
          withGtkWrapper = false;
          isNixOS = true;
        };
      };
    };
}
