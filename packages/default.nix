{
  self,
  inputs,
  ...
}: let
  /*
  wrapperFor returns a wrapper w for a set of pkgs

  wrapper incudes automatic overrides for a callPackage definition
  */
  wrapperFor = _pkgs: _callPackage: path: extraOverrides: let
    # args :: set
    args = builtins.functionArgs (import path);

    nvfetcherOverrides =
      if builtins.hasAttr "sources" args
      then {
        # Use a standard callPackage for the sources
        sources = _pkgs.callPackage (path + "/generated.nix") {};
      }
      else if builtins.hasAttr "src" args
      then builtins.head (builtins.attrValues (builtins.removeAttrs (_pkgs.callPackage (path + "/generated.nix") {}) ["override" "overrideDerivation"]))
      else {};
  in
    _callPackage path (nvfetcherOverrides // extraOverrides);
in {
  flake.overlays.wlroots-nvidia = final: prev: {
    # wlroots = prev.wlroots.overrideAttrs (old: {
    #   pname = "wlroots-nvidia";
    #   postPatch =
    #     (old.postPatch or "")
    #     + ''
    #       substituteInPlace render/gles2/renderer.c --replace "glFlush();" "glFinish();"
    #     '';
    # });
  };

  perSystem = {
    pkgs,
    system,
    config,
    ...
  }: let
    w = wrapperFor pkgs;
  in {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        self.overlays.wlroots-nvidia
      ];
    };

    legacyPackages = pkgs;

    packages = {
      # Main
      adw-gtk3 = w pkgs.callPackage ./main/adw-gtk3 {};
      colloid = w pkgs.callPackage ./main/colloid {};
      # hcl = w pkgs.callPackage ./main/hcl {}; # golang hashes broken
      plasma-applet-splitdigitalclock = w pkgs.callPackage ./main/plasma-applet-splitdigitalclock {};
      present = w pkgs.callPackage ./main/present {};
      tailscale-systray = w pkgs.callPackage ./main/tailscale-systray {};
      toml-fmt = w pkgs.callPackage ./main/toml-fmt {};
      vlmcsd = w pkgs.callPackage ./main/vlmcsd {};
      xdg-ninja = w pkgs.callPackage ./main/xdg-ninja {};

      # Python
      resolve-march-native = w pkgs.python3.pkgs.callPackage ./python/resolve-march-native {};

      # Qt5
      bismuth = w pkgs.libsForQt5.callPackage ./qt5/bismuth {};
      kwin-forceblur = w pkgs.libsForQt5.callPackage ./qt5/kwin-forceblur {};
      lightly = w pkgs.libsForQt5.callPackage ./qt5/lightly {};
      reversal-kde = w pkgs.libsForQt5.callPackage ./qt5/reversal-kde {};
      sierrabreezeenhanced = w pkgs.libsForQt5.callPackage ./qt5/sierrabreezeenhanced {};

      # Fonts
      comic-code = w pkgs.callPackage ./fonts/comic-code {};
      hoefler-text = w pkgs.callPackage ./fonts/hoefler-text {};
      redaction = w pkgs.callPackage ./fonts/redaction {};
      san-francisco = w pkgs.callPackage ./fonts/san-francisco {};

      # Overrides
      nix-index = w pkgs.callPackage ./overrides/nix-index {
        # TODO it should build under aarch64
        database = inputs.nix-index-database.legacyPackages."x86_64-linux".database;
        databaseDate = self.lib.mkDate inputs.nix-index-database.lastModifiedDate;
      };
      fish = w pkgs.callPackage ./overrides/fish {
        inherit (config.packages) nix-index any-nix-shell;
      };
      fish-debug = config.packages.fish.override {debug = true;};
      zsh = w pkgs.callPackage ./overrides/zsh {
        inherit (config.packages) nix-index;
      };
      #
      any-nix-shell = w pkgs.callPackage ./overrides/any-nix-shell {};
      awesome = w pkgs.callPackage ./overrides/awesome {};
      neofetch = w pkgs.callPackage ./overrides/neofetch {};
      neovim = w pkgs.callPackage ./overrides/neovim {};
      obsidian = w pkgs.callPackage ./overrides/obsidian {};
      papirus-icon-theme = w pkgs.callPackage ./overrides/papirus-icon-theme {};
      picom = w pkgs.callPackage ./overrides/picom {};
      rose-pine-gtk-theme = w pkgs.callPackage ./overrides/rose-pine-gtk-theme {};
      shfmt = w pkgs.callPackage ./overrides/shfmt {};
      stylua = w pkgs.callPackage ./overrides/stylua {};
      git = w pkgs.callPackage ./overrides/git {};
      wezterm = w pkgs.callPackage ./overrides/wezterm {};
      foot = w pkgs.callPackage ./overrides/foot {};
    };
  };
}
