{ pkgs, lib, ... }:
let
  recursiveUpdateFold = builtins.foldl' lib.recursiveUpdate { };

  config = recursiveUpdateFold [
    (lib.importTOML ./alacritty.toml)
    (lib.importTOML ./theme.toml)
    ({
      terminal.shell.program = pkgs.writeShellScript "alacritty-start" ''
        if [[ $(type -P tmux) ]]; then
          exec tmux new-session -A -s main
        else
          exec "$SHELL"
        fi
      '';
    })
  ];
in
{
  wrappers.alacritty = {
    basePackage = pkgs.alacritty;
    flags = [
      "--config-file"
      ((pkgs.formats.toml { }).generate "alacritty.toml" config)
    ];
  };
}
