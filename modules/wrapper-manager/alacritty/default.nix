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
      # (lib.importTOML ./theme.toml)
      (lib.importTOML ./mocha.toml)
      {
        # terminal.shell.program = pkgs.writeShellScript "alacritty-start" ''
        #   if [[ $(type -P tmux) ]]; then
        #     exec tmux new-session -A -s main
        #   else
        #     exec "$SHELL"
        #   fi
        # '';
        terminal.shell.program = pkgs.writeShellScript "alacritty-start" ''
          if [[ $(type -P zellij) ]]; then
            exec zellij attach -c main
          else
            exec "$SHELL"
          fi
        '';

        keyboard.bindings =
          (lib.range 65 90)
          |> (builtins.filter (
            n:
            !(builtins.elem n [
              # 67 # C
              86 # V
            ])
          ))
          |> (map (n: {
            key = builtins.getAttr (builtins.toString n) ascii-table';
            mods = "Control | Shift";
            chars = "${esc}[${builtins.toString n};5u";
          }));
      }
    ];

    wrappers.alacritty = {
      basePackage = pkgs.alacritty;
      prependFlags = [
        "--config-file"
        ((pkgs.formats.toml { }).generate "alacritty.toml" config.alacrittyConfig)
      ];
    };
  };
}
