{
  sources,
  #
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
  withNodeJs = false;
  withPython3 = false;
  customRC = ''
    source ${./init.vim}
    :luafile ${./init.lua}
  '';

  # https://nixos.org/manual/nixpkgs/stable/#managing-plugins-with-vim-packages

  configure.packages."placeholder".start = with vimPlugins; let
    _extraPlugins = builtins.mapAttrs (_: value: vimUtils.buildVimPlugin value) sources;
    extraPlugins = builtins.removeAttrs _extraPlugins ["override" "overrideDerivation"];
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
  in
    [
      # Theming
      # vim-one
      nvim-web-devicons
      gitsigns-nvim
      bufferline-nvim
      lualine-nvim

      # Misc
      vim-highlightedyank
      indent-blankline-nvim
      auto-pairs
      nvim-comment
      editorconfig-vim

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
    ]
    ++ builtins.attrValues extraPlugins;
})
