{
  config,
  pkgs,
  packages,
  ...
}: {
  home.sessionVariables.EDITOR = "nvim";

  home.packages = [
    packages.self.g-neovim
    pkgs.rnix-lsp
  ];

  # programs.neovim = {
  #   enable = false;
  #   package = pkgs.g-neovim;

  # extraConfig = ''
  #   " Vanilla configs
  #   ${builtins.readFile ./vanilla.vim}

  #   " Plugins configs
  #   ${builtins.readFile ./plugins.vim}

  #   " Lua config
  #   :luafile ${./plugins.lua}
  # '';

  # withNodeJs = true;

  # extraPackages = with pkgs; [
  #   tree-sitter
  # ];

  # # coc = {
  # #   enable = true;
  # #   settings = "${builtins.readFile ./coc-settings.json}";
  # # };

  # plugins = let
  #   src-plugins = {
  #     # keep
  #   };

  #   nixpkgs-plugins = with pkgs.vimPlugins; [
  #     vim-one

  #     nvim-web-devicons
  #     gitsigns-nvim
  #     bufferline-nvim
  #     lualine-nvim

  #     # nvim-lspconfig
  #     nvim-treesitter
  #     # vim-nix

  #     vim-highlightedyank
  #     indent-blankline-nvim
  #     auto-pairs
  #     nvim-comment
  #     editorconfig-vim
  #   ];

  #   vim-extra-plugins = with pkgs.vimExtraPlugins; [
  #     nvim-transparent
  #   ];
  # in
  #   nixpkgs-plugins ++ vim-extra-plugins ++ (builtins.attrValues src-plugins);
  # };
}
