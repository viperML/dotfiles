# Many things stolen from https://github.com/Gerg-L/mnw :)
{
  pkgs,
  lib,
  inputs',
  config,
  ...
}:
{
  wrappers.neovim =
    let
      inherit (builtins)
        typeOf
        mapAttrs
        ;

      basePackage = pkgs.neovim-unwrapped;

      packName = "viper-pack";

      nvGenerated = pkgs.callPackages ./_sources/generated.nix { };

      nvPlugins =
        nvGenerated
        |> (mapAttrs (
          name: value:
          value.src.overrideAttrs (
            finalAttrs: prevAttrs: {
              pname =
                if builtins.hasAttr "repo" value.src then value.src.repo else builtins.baseNameOf value.src.url;
              version = lib.removePrefix "v" value.version;
              name = with finalAttrs; "${pname}-${version}";
            }
          )
        ));

      luaPackages = lp: [
        lp.luassert
        lp.luaposix
        lp.lyaml
      ];

      luaEnv = basePackage.lua.withPackages luaPackages;
      inherit (basePackage.lua.pkgs.luaLib) genLuaPathAbsStr genLuaCPathAbsStr;

      plugins = lib.fix (p: {
        start =
          {
            inherit (pkgs.vimPlugins)
              lz-n
              nvim-web-devicons
              snacks-nvim
              plenary-nvim
              mini-nvim
              kanagawa-nvim
              bufferline-nvim
              lualine-nvim
              ;

            viper-init-plugin = ./viper-init-plugin;
            viper-pre-init-plugin = pkgs.runCommandLocal "viper-pre-init-plugin" { } ''
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
          }
          // (lib.getAttrs (map (name: "tree-sitter-${name}") [
            # grammars are slow AF, so don't pull the grammars for potentially big files like JSON
            "asm"
            "astro"
            "bash"
            "c"
            "cmake"
            "cpp"
            "elixir"
            "fish"
            "git_config"
            "glsl"
            "go"
            "haskell"
            "hcl"
            "html"
            "javascript"
            "lua"
            "markdown"
            # "meson"
            "nix"
            "org"
            "regex"
            "rust"
            "scheme"
            "tsx"
            "typescript"
            "typst"
            "yaml" # for frontmatter injections
          ]) inputs'.tree-sitter.legacyPackages.nvim-grammars.filtered);

        opt = (builtins.removeAttrs nvPlugins (builtins.attrNames p.start)) // {
          inherit (inputs'.tree-sitter.packages) nvim-treesitter;
          inherit (pkgs.vimPlugins)
            nvim-ts-autotag
            nvim-treesitter-context
            nvim-treesitter-textobjects

            # codecompanion-nvim
            avante-nvim
            comment-nvim
            conform-nvim
            git-conflict-nvim
            gitsigns-nvim
            haskell-tools-nvim
            indent-blankline-nvim
            marks-nvim
            neo-tree-nvim
            noice-nvim
            nui-nvim
            nvim-autopairs
            nvim-lspconfig
            blink-cmp
            nvim-navic
            parinfer-rust
            render-markdown-nvim
            smart-splits-nvim
            telescope-fzf-native-nvim
            telescope-nvim
            trouble-nvim
            vim-better-whitespace
            vim-nix
            which-key-nvim
            yazi-nvim
            ;
        };
      });

      linkPlugin =
        { plugin, startOpt }:
        let
          name =
            if typeOf plugin == "path" then
              baseNameOf plugin
            else if plugin ? pname then
              plugin.pname
            else
              plugin.name;
          name' = if name == "source" then throw "Plugin ${plugin} is doesn't have a proper pname" else name;
        in
        ''
          ln -vsfT ${plugin} $out/pack/${packName}/${startOpt}/${name'}
        '';

      packDir = pkgs.runCommandLocal "pack-dir" { } ''
        mkdir -pv $out/pack/${packName}/{start,opt}

        ${
          plugins.start
          |> builtins.attrValues
          |> (map (
            plugin:
            linkPlugin {
              inherit plugin;
              startOpt = "start";
            }
          ))
          |> (lib.concatStringsSep "\n")
        }

        ${
          plugins.opt
          |> builtins.attrValues
          |> (map (
            plugin:
            linkPlugin {
              inherit plugin;
              startOpt = "opt";
            }
          ))
          |> (lib.concatStringsSep "\n")
        }
      '';
    in
    {
      inherit basePackage;
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
          value = "nvim-viper";
        };
      };
      flags = [
        "-u"
        "NORC"
        "--cmd"
        "lua vim.loader.enable()"
        "--cmd"
        "set packpath^=${packDir} | set runtimepath^=${packDir}"
      ];
      overrideAttrs =
        old:
        let
          pname = config.wrappers.neovim.env.NVIM_APPNAME.value;
          inherit (config.wrappers.neovim.basePackage) version;
        in
        {
          name = "${pname}-${version}";
          passthru = (old.passthru or { }) // {
            inherit packDir;
          };
        };
      postBuild = ''
        export HOME="$(mktemp -d)"
        export NVIM_SILENT=1
        $out/bin/nvim --headless '+lua =require("viper.health").loaded_exit()' '+q'
      '';
    };
}
