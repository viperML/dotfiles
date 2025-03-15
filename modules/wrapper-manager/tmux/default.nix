{ pkgs, lib, ... }:
let
  plugins = with pkgs.tmuxPlugins; [
  ];
in
{
  wrappers.tmux = {
    basePackage = pkgs.tmux;
    flags = [
      "-f"
      (pkgs.writeText "tmux-conf" ''
        run-shell ${pkgs.tmuxPlugins.sensible.rtp}

        source-file ${./tmux.conf}

        ${plugins |> (map (plugin: "run-shell ${plugin.rtp}")) |> (lib.concatStringsSep "\n")}
      '')
    ];
    extraWrapperFlags = ''
      --run 'export TMUX_TMPDIR="''${XDG_RUNTIME_DIR}"'
    '';
  };
}
