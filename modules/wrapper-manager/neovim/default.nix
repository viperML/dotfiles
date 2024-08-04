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
      mkEntryFromDrv = drv: {
        name = drv.pname or drv.name;
        path = drv;
      };
    in
      pkgs.linkFarm name (map mkEntryFromDrv drvs);

    pluginFarm = linkFarmFromDrvs' "pluginFarm" (plugins
      ++ [
        inputs'.tree-sitter.packages.nvim-treesitter
      ]
      ++ (lib.attrValues inputs'.tree-sitter.legacyPackages.grammars.filtered));

    packDir = pkgs.runCommand "pack-dir" {} ''
      mkdir -p $out/pack/p
      ln -vsfT ${pluginFarm} $out/pack/p/start
    '';
  in {
    basePackage = pkgs.neovim-unwrapped;
    env.NVIM_SYSTEM_RPLUGIN_MANIFEST = {
      value =
        pkgs.writeText "rplugin.vim"
        #vim
        ''
          " empty
        '';
      force = true;
    };
    flags = [
      "-u"
      (pkgs.writeText "init.lua"
        #lua
        ''
          vim.g.loaded_node_provider=0
          vim.g.loaded_perl_provider=0
          vim.g.loaded_python_provider=0
          vim.g.loaded_python3_provider=0
          vim.g.loaded_ruby_provider=0

          dofile("${./init.lua}")
        '')
      "--cmd"
      "set packpath^=${packDir}"
      "--cmd"
      "set rtp^=${packDir}"
    ];
  };
}
