{ pkgs, lib, ... }:
let
  recursiveUpdateFold = builtins.foldl' lib.recursiveUpdate { };

  config = recursiveUpdateFold [
    (lib.importTOML ./alacritty.toml)
    (lib.importTOML ./theme.toml)
    (
      let
        multiplexer = "tmux";
      in
      {
        terminal.shell.program = pkgs.writeShellScript "alacritty-start" ''
          if [[ $(type -P ${multiplexer}) ]]; then
            exec ${multiplexer}
          else
            exec "$SHELL"
          fi
        '';
      }
    )
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
