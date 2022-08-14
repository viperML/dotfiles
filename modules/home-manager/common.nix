{
  config,
  pkgs,
  lib,
  inputs,
  self,
  packages,
  ...
}: {
  # Generic programs
  home.packages = with pkgs; [
    # Nix management
    direnv
    alejandra
    nvfetcher

    # Editor support
    packages.self.nil

    # Misc utils
    file
    lsof
    dogdns
    fd
    htop
    # jless
    jq
    ripgrep
    # tealdeer
    bubblewrap
    wormhole-william
    packages.self.neofetch
    packages.self.vshell
    packages.self.neovim
  ];

  home.stateVersion = "21.11";

  nix.extraOptions = lib.fileContents "${self}/misc/nix.conf";

  xdg.configFile."direnv/direnvrc".text = ''
    source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc
  '';
}
