{
  config,
  pkgs,
  ...
}: {
  xdg.configFile."starship.toml".text = ''
    ${builtins.readFile ./starship.toml}

    [custom.nix]
    command = "${pkgs.any-nix-shell}/bin/nix-shell-info"
    when = "${pkgs.any-nix-shell}/bin/nix-shell-info"
    symbol = ""
    style = "bold cyan"
    format = """>>= [$symbol]($style) [$output]($style)
    """
  '';
}
