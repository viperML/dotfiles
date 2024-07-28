{
  vimPlugins,
  vimUtils,
  callPackages,
  neovimUtils,
  wrapNeovimUnstable,
  neovim-unwrapped,
  lib,
  ripgrep,
  fd,

  ts-all-grammars,
}: let
  nvfetcher = builtins.mapAttrs (name: value:
    vimUtils.buildVimPlugin {
      inherit name;
      inherit (value) src;
    }) (callPackages ./generated.nix {});

  neovimConfig = neovimUtils.makeNeovimConfig {
    withPython3 = false;
    withRuby = false;
    withNodeJs = false;

    extraLuaPackages = (lp: []);

    customRC = ''
      source ${./init.vim}
      :luafile ${./init.lua}
    '';

    plugins =
      (builtins.attrValues nvfetcher)
      ++ (with vimPlugins; [
        # All
        bufferline-nvim
        lualine-nvim
        nvim-web-devicons
        gitsigns-nvim
        vim-highlightedyank
        indent-blankline-nvim-lua
        nvim-autopairs
        neo-tree-nvim
        comment-nvim
        which-key-nvim
        conform-nvim
        telescope-nvim

        # Language support
        nvim-lspconfig
        nvim-cmp
        cmp-cmdline
        cmp-nvim-lsp
        cmp-buffer
        cmp-path

        # nvim-treesitter.withAllGrammars
        (nvim-treesitter.withPlugins (_: ts-all-grammars))

        vim-nix
        # conjure
        # cmp-conjure
        orgmode
        parinfer-rust
        nvim-paredit

        ## -- Unsorted
      ]);
  };
in
  wrapNeovimUnstable neovim-unwrapped (neovimConfig // {
    wrapperArgs = neovimConfig.wrapperArgs ++ [
      # extra runtime deps
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath [
        ripgrep
        fd
      ])
    ];
  })
