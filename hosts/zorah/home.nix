{
  pkgs,
  self',
  config,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

  unsafeFlakePath = "/home/ayats/Documents/dotfiles";

  home.packages = [
    pkgs.vscode
    self'.packages.wezterm
    pkgs.onlyoffice-bin
    pkgs.sops
    pkgs.age

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
    secrets.git_config = {};
    secrets.ssh_config = {};
  };

  home.activation.setupSops = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    /run/current-system/sw/bin/systemctl start --user sops-nix
    ln $VERBOSE_ARG -sfT $XDG_RUNTIME_DIR/secrets/git_config $XDG_CONFIG_HOME/git/local
    ln $VERBOSE_ARG -sfT $XDG_RUNTIME_DIR/secrets/ssh_config $HOME/.ssh/config
  '';
}
