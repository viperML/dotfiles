{
  config,
  pkgs,
  packages,
  ...
}: {
  xdg.configFile."starship.toml".text = ''
    ${builtins.readFile ./starship.toml}

    [custom.nix]
    command = "${packages.self.any-nix-shell}/bin/nix-shell-info"
    when = "${packages.self.any-nix-shell}/bin/nix-shell-info"
    symbol = ""
    style = "bold cyan"
    format = """>>= [$symbol]($style) [$output]($style)
    """
  '';
}
