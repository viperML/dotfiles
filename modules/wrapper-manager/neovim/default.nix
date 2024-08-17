/*
Many things stolen from https://github.com/Gerg-L/mnw :)
*/
{
  pkgs,
  lib,
  inputs',
  config,
  ...
}: {
  wrappers.neovim = let
    inherit
      (lib)
      traceVal
      traceValFn
      concatMapStringsSep
      flatten
      ;

    inherit
      (builtins)
      typeOf
      mapAttrs
      attrValues
      readFile
      ;

    basePackage = pkgs.neovim-unwrapped;

    packName = "viper-pack";

    nv = fromTOML (readFile ./nvfetcher.toml);

    nvGenerated = pkgs.callPackages ./generated.nix {};

    nvPlugins =
      mapAttrs (name: value: (value.src.overrideAttrs (old: let
        original = nv.${name};
        pname =
          if original ? src.git
          then baseNameOf original.src.git
          else if original ? src.github
          then baseNameOf original.src.github
          else builtins.trace original throw "src wasn't git or github";
        version =
          if builtins.hasAttr "date" value
          then value.date
          else lib.removePrefix "v" value.version;
      in {
        inherit pname version;
        name = "${pname}-${version}";
        passthru.opt = (
          if (value ? opt)
          then builtins.fromJSON value.opt
          else false
        );
      })))
      nvGenerated;

    nvPlugins' =
      nvPlugins
      // {
        telescope-fzf-native-nvim = let
          base = nvGenerated.telescope-fzf-native-nvim;
        in
          with pkgs;
            stdenv.mkDerivation {
              inherit (base) pname src;
              version = base.date;
              nativeBuildInputs = [cmake];
              cmakeFlags = [
                # "-B build"
              ];
              # crimes against humanity
              installPhase = ''
                mkdir -p $out
                cp -vr ${base.src}/{*,.*} $out
                mkdir -p $out/build
                cp -vr ./*.so $out/build/
              '';
            };
      };

    luaPackages = lp: [
      lp.luassert
      # lp.lua-cjson
    ];

    luaEnv = basePackage.lua.withPackages luaPackages;
    inherit (basePackage.lua.pkgs.luaLib) genLuaPathAbsStr genLuaCPathAbsStr;

    viper-pre-init-plugin =
      pkgs.runCommandLocal "viper-pre-init-plugin" {
        passthru.opt = false;
      }
      # bash
      ''
        mkdir -p $out/plugin

        tee $out/plugin/init.lua <<EOF
        -- Don't use LUA_PATH or LUA_CPATH because they leak into the LSP
        package.path = "${genLuaPathAbsStr luaEnv};" .. package.path
        package.cpath = "${genLuaCPathAbsStr luaEnv};" .. package.cpath

        -- No remote plugins
        vim.g.loaded_node_provider = 0
        vim.g.loaded_perl_provider = 0
        vim.g.loaded_python_provider = 0
        vim.g.loaded_python3_provider = 0
        vim.g.loaded_ruby_provider = 0
        EOF
      '';

    makeOpt = drv:
      drv.overrideAttrs (old: {
        passthru =
          (old.passthru or {})
          // {
            opt = true;
          };
      });

    allPlugins = flatten [
      viper-pre-init-plugin
      (attrValues nvPlugins')

      (makeOpt inputs'.tree-sitter.packages.nvim-treesitter)
      (lib.attrValues (builtins.removeAttrs inputs'.tree-sitter.legacyPackages.grammars.filtered [
        "tree-sitter-comment"
      ]))

      (makeOpt pkgs.vimPlugins.parinfer-rust)
    ];

    packDir =
      pkgs.runCommandLocal "pack-dir" {}
      # bash
      ''
        mkdir -pv $out/pack/${packName}/{start,opt}

        ${concatMapStringsSep "\n" (p: ''
            ln -vsfT ${p} $out/pack/${packName}/${
              if p ? passthru.opt && p.passthru.opt
              then "opt"
              else "start"
            }/${
              if typeOf p == "path"
              then baseNameOf p
              else if p ? pname
              then p.pname
              else p.name
            }
          '')
          allPlugins}

        ln -vsfT ${./viper-init-plugin} $out/pack/${packName}/start/viper-init-plugin
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
        value = "nvim-viper-3";
      };
    };
    flags = [
      "-u"
      "NORC"
      "--cmd"
      "set packpath^=${packDir} | set runtimepath^=${packDir}"
    ];
    overrideAttrs = old: let
      pname = config.wrappers.neovim.env.NVIM_APPNAME.value;
      inherit (config.wrappers.neovim.basePackage) version;
    in {
      name = "${pname}-${version}";
      passthru =
        (old.passthru or {})
        // {
          inherit packDir;
        };
    };
  };
}
