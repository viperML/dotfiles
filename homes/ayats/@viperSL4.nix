{
  config,
  packages,
  ...
}: {
  unsafeFlakePath = "${config.home.homeDirectory}/Projects/dotfiles";

  home.packages = [
    # packages.self.helix
  ];
}
