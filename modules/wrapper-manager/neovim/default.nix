{
  pkgs,
  lib,
  inputs',
  ...
}: {
  wrappers.neovim = let
    nv = pkgs.callPackages ./generated.nix {};

    plugins = lib.pipe nv [
      lib.attrsToList
      (map (x @ {
        name,
        value,
      }:
        value.src.overrideAttrs (old: rec {
          pname = x.name;
          version =
            if builtins.hasAttr "date" value
            then value.date
            else lib.removePrefix "v" value.version;
          name = "${pname}-${version}";
        })))
    ];

    linkFarmFromDrvs' = name: drvs: let
      mkEntryFromDrv = elem: {
        name =
          if builtins.typeOf elem == "path"
          then builtins.baseNameOf elem
          else elem.pname or elem.name;
        path = elem;
      };
    in
      pkgs.linkFarm name (map mkEntryFromDrv drvs);

    pluginFarm = linkFarmFromDrvs' "pluginFarm" (lib.flatten [
      ./init-plugin
      plugins
      inputs'.tree-sitter.packages.nvim-treesitter
      pkgs.vimPlugins.parinfer-rust
      (lib.attrValues inputs'.tree-sitter.legacyPackages.grammars.filtered)
    ]);

    packDir = pkgs.runCommand "pack-dir" {} ''
      mkdir -p $out/pack/p
      ln -vsfT ${pluginFarm} $out/pack/p/start
    '';
  in {
    basePackage = pkgs.neovim-unwrapped;
    env = {
      NVIM_SYSTEM_RPLUGIN_MANIFEST = {
        value =
          pkgs.writeText "rplugin.vim"
          #vim
          ''
            " empty
          '';
        force = true;
      };
      NVIM_APPNAME = {
        value = "nvim-nix";
      };
    };
    flags = [
      "-u" "NORC"
      "--cmd"
      "set packpath^=${packDir} | set rtp^=${packDir})"
    ];
  };
}
