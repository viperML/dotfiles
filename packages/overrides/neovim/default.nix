{
  wrapNeovimUnstable,
  neovim-unwrapped,
  neovimUtils,
  vimPlugins,
  vimUtils,
  fetchFromGitHub,
  symlinkJoin,
  makeWrapper,
}:
wrapNeovimUnstable (symlinkJoin {
  inherit (neovim-unwrapped) name pname version;
  paths = [neovim-unwrapped];
  nativeBuildInputs = [makeWrapper];
  postBuild = ''
    wrapProgram $out/bin/nvim \
      --unset NIX_LD \
      --unset NIX_LD_LIBRARY_PATH
  '';
}) (neovimUtils.makeNeovimConfig {
  extraLuaPackages = luaPackages:
    with luaPackages; [
      # keep
    ];
  withNodeJs = true;
  withPython3 = true;
  extraPython3Packages = pythonPackages:
    with pythonPackages; [
      # keep
    ];
  customRC = ''
    source ${./init.vim}
    :luafile ${./init.lua}
  '';

  # https://nixos.org/manual/nixpkgs/stable/#managing-plugins-with-vim-packages

  configure.packages."placeholder".start = with vimPlugins; let
    nvim-transparent = vimUtils.buildVimPlugin {
      pname = "nvim-transparent";
      version = "unstable-2022-04-13";
      src = fetchFromGitHub {
        owner = "xiyaowong";
        repo = "nvim-transparent";
        rev = "ed488bee61d544f9a52516c661f5df493253a1b4";
        sha256 = "08fnbqb10zxc6qwiswnqa5xf9g8k9q8pg5mwrl2ww2qcxnxbfw1p";
      };
      meta = {
        description = "Remove all background colors to make nvim transparent";
        homepage = "https://github.com/xiyaowong/nvim-transparent";
      };
    };
    vim-colors-bionik = vimUtils.buildVimPlugin {
      pname = "vim-colors-bionik";
      version = "unstable-2021-11-28";
      src = fetchFromGitHub {
        owner = "datMaffin";
        repo = "vim-colors-bionik";
        rev = "ed4440063bcf13e180b6e602dbad85e206afd73a";
        sha256 = "1j39kg4raaw8cf0f4kgg31g6p8g89nrg8k9hzw3r30b43hnblbzl";
      };
    };
    nvim-treesitter' = nvim-treesitter.withPlugins (p:
      with p; [
        tree-sitter-bash
        tree-sitter-dockerfile
        tree-sitter-json
        tree-sitter-json5
        # tree-sitter-nix
        tree-sitter-python
        tree-sitter-toml
      ]);
  in [
    # Theming
    # vim-one
    nvim-web-devicons
    gitsigns-nvim
    bufferline-nvim
    lualine-nvim
    vim-colors-bionik

    # Misc
    vim-highlightedyank
    indent-blankline-nvim
    auto-pairs
    nvim-comment
    editorconfig-vim
    nvim-transparent

    # Intelligent editor
    nvim-lspconfig
    nvim-cmp
    cmp-cmdline
    cmp-nvim-lsp
    cmp-buffer
    cmp-path

    nvim-treesitter'
    vim-nix
    neoformat
  ];
})
