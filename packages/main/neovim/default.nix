{
  wrapNeovimUnstable,
  neovim-unwrapped,
  neovimUtils,
  vimPlugins,
  vimUtils,
  formats,
  writeTextDir,
  fetchFromGitHub,
  lib,
}:
wrapNeovimUnstable neovim-unwrapped (neovimUtils.makeNeovimConfig {
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
    " Vanilla configs
    ${lib.fileContents ./vanilla.vim}

    " Plugins configs
    ${lib.fileContents ./plugins.vim}
    let g:coc_config_home="${writeTextDir "coc" ((formats.json {}).generate "coc-settings.json" (import ./coc.nix))}"

    " Lua config
    :luafile ${./plugins.lua}
  '';

  # No idea of how all of this is passed down
  # https://github.com/NixOS/nixpkgs/blob/2ea2f7b6d0cb7ce0712f2aa80303cda08deb0de2/pkgs/applications/editors/vim/plugins/vim-utils.nix#L267
  # configure === vimrcContent

  configure.plug.plugins = with vimPlugins; let
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
  in [
    # Theming
    vim-one
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
    nvim-transparent

    # Intelligent editor
    nvim-lspconfig
    vim-nix
    coc-nvim
    neoformat
  ];
})
