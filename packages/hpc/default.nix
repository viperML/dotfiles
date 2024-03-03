{ pkgs, packages }:
pkgs.buildEnv {
  name = "hpc";
  paths = [
    pkgs.nix
    pkgs.direnv
    pkgs.nixfmt-rfc-style
    # packages.self.nvfetcher
    packages.nh.default
    pkgs.nix-output-monitor
    # packages.self.dotci

    # Editor support
    pkgs.nil

    # Misc utils
    # pkgs.file
    # pkgs.lsof
    # pkgs.dogdns
    # pkgs.fd
    # pkgs.htop
    # pkgs.libarchive
    # pkgs.jq
    pkgs.ripgrep
    pkgs.skim
    # pkgs.bubblewrap
    pkgs.magic-wormhole-rs
    # packages.self.zellij
    pkgs.du-dust
    pkgs.hexyl
    pkgs.unar
    pkgs.gh
    # packages.self.elf-info
    pkgs.elf-info
    # pkgs.nix-init

    packages.self.fish
    # packages.self.nushell
    packages.self.neovim
  ];
}
