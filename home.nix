{ config, pkgs, ... }:

{

  home.username = "ayats";
  home.homeDirectory = "/home/ayats";

  home.packages = [
    /* pkgs.fortune */
  ];


  programs.home-manager = {
    enable = true;
    path = "…";
  };
  
  programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        dracula-vim
      ];
      extraConfig = ''
        ${builtins.readFile ./neovim/base.vim}
      '';


      #   let
      #     context-vim = pkgs.vimUtils.buildVimPlugin {
      #       name = "context-vim";
      #       src = pkgs.fetchFromGitHub {
      #         owner = "wellle";
      #         repo = "context.vim";
      #         rev = "e38496f1eb5bb52b1022e5c1f694e9be61c3714c";
      #         sha256 = "1iy614py9qz4rwk9p4pr1ci0m1lvxil0xiv3ymqzhqrw5l55n346";
      #       };
      #     };
      #   in [
      #     context-vim
      #     editorconfig-vim
      #     gruvbox-community
      #     vim-airline
      #     vim-elixir
      #     vim-nix
      #   ]; # Only loaded if programs.neovim.extraConfig is set
      # /* viAlias = true; */
      # /* vimAlias = true; */
      # /* vimdiffAlias = true; */
    };
}
