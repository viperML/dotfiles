{
  pkgs,
  self',
  config,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  unsafeFlakePath = "/home/ayats/Documents/dotfiles";

  home.packages = [
    pkgs.vscode
    self'.packages.wezterm
    pkgs.onlyoffice-bin
    pkgs.sops
    pkgs.age
    pkgs.d-spy
    pkgs.rsync

    # global dev
    pkgs.just
    pkgs.clang-tools
    pkgs.hyperfine
    pkgs.cntr
    pkgs.sshfs
    pkgs.strace
    pkgs.gdb
  ];

  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = ./private.yaml;
    secrets.git_config = {
      path = "${config.xdg.configHome}/git/local";
    };
    secrets.ssh_config = {
      path = "${config.home.homeDirectory}/.ssh/config";
    };
  };
}
