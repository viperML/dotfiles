{
  pkgs,
  lib,
  config,
  ...
}:
let
  ascii-table = import "${pkgs.path}/lib/ascii-table.nix";
  ascii-table' = lib.mapAttrs' (name: value: {
    name = builtins.toString value;
    value = name;
  }) ascii-table;
  tomlFormat = pkgs.formats.toml { };
  esc = builtins.fromJSON ''"\u001b"'';
in
{
  options = {
    alacrittyConfig = lib.mkOption {
      default = { };
      type = tomlFormat.type;
    };
  };

  config = {
    alacrittyConfig = lib.mkMerge [
      (lib.importTOML ./alacritty.toml)
      (lib.importTOML ./theme.toml)
      {
        terminal.shell.program = pkgs.writeShellScript "alacritty-start" ''
          if [[ $(type -P tmux) ]]; then
            exec tmux new-session -A -s main
          else
            exec "$SHELL"
          fi
        '';

        keyboard.bindings =
          (lib.range 65 90)
          |> (map (n: {
            key = builtins.getAttr (builtins.toString n) ascii-table';
            mods = "Control | Shift";
            chars = "${esc}[${builtins.toString n};5u";
          }));
      }
    ];

    wrappers.alacritty = {
      basePackage = pkgs.alacritty;
      flags = [
        "--config-file"
        ((pkgs.formats.toml { }).generate "alacritty.toml" config.alacrittyConfig)
      ];
    };
  };
}
