lib:
let
  inherit (builtins)
    mapAttrs
    readDir
    ;

  sources = import ../npins;

  overlayPatches = final: prev: {
    # gnome-keyring = prev.gnome-keyring.overrideAttrs (old: {
    #   # configureFlags = (lib.remove "--enable-ssh-agent" old.configureFlags) ++ [
    #   #   "--disable-ssh-agent"
    #   # ];
    #   mesonFlags = (lib.remove "-Dssh-agent=true" old.mesonFlags) ++ [
    #     "-Dssh-agent=false"
    #   ];
    # });
  };

  overlayAuto =
    final: prev:
    (
      readDir ./.
      |> lib.filterAttrs (_: value: value == "directory")
      |> mapAttrs (
        name: _:
        final.callPackage ./${name} {
        }
      )
    )
    // {
      # Prevent infrec
      yazi = final.callPackage ./yazi { inherit (prev) yazi; };
    };

  overlayMisc = final: prev: {
    # nix = flake.self.lib.versionGate pkgs.nixVersions.nix_2_26 pkgs.nix;
    nix = prev.nix;

    nix-index =
      let
        imported = import sources.nix-index-database { pkgs = final; };
      in
      imported.nix-index-with-db;

    neovim = (import sources.mnw).lib.wrap final { imports = [ ./neovim/module.nix ]; };

    nh = final.callPackage "${sources.nh}/package.nix" {
      rev = sources.nh.revision;
    };

    hover-rs = final.callPackage "${sources.hover-rs}/package.nix" { };

    maid = (import sources.nix-maid) final ../modules/maid;

    zen-browser = ((import sources.zen-browser-flake) { pkgs = final; }).zen-browser;
  };

  overlayWrapperManager =
    final: prev:
    let
      wrapper-manager = import sources.wrapper-manager;
      evald = wrapper-manager.lib {
        pkgs = prev;
        modules =
          builtins.readDir ../modules/wrapper-manager
          |> builtins.attrNames
          |> map (n: ../modules/wrapper-manager/${n});
      };
    in
    mapAttrs (_: value: value.wrapped) evald.config.wrappers;

  overlayVersion = final: prev: {
    lib = prev.lib.extend (
      finalLib: prevLib: {
        trivial = prevLib.trivial // {
          versionSuffix = ".${finalLib.substring 0 7 sources.nixpkgs.revision}";
        };
      }
    );
  };
in
lib.composeManyExtensions [
  overlayPatches
  overlayAuto
  overlayMisc
  overlayWrapperManager
  # (import sources.lanzaboote).overlays.default
  overlayVersion
]
