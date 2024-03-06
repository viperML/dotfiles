{ pkgs
, packages
, lib
, ...
}: {
  nixpkgs.config.allowUnfree = true;

  unsafeFlakePath = "/home/ayats/Documents/dotfiles";

  home.packages = [
    pkgs.vscode
    packages.self.wezterm
    pkgs.onlyoffice-bin
    pkgs.sops
    pkgs.age

    # global dev
    pkgs.just
    pkgs.clang-tools
    pkgs.cargo-flamegraph
    pkgs.linuxPackages.perf
    pkgs.hyperfine
  ];
}