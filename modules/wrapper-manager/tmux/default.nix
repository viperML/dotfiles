{ pkgs, lib, ... }:
let
  plugins = with pkgs.tmuxPlugins; [
  ];
in
{
  wrappers.tmux = {
    basePackage = pkgs.tmux;
    prependFlags = [
      "-f"
      (pkgs.writeText "tmux-conf" ''
        run-shell ${pkgs.tmuxPlugins.sensible.rtp}

        source-file ${./tmux.conf}

        ${plugins |> (map (plugin: "run-shell ${plugin.rtp}")) |> (lib.concatStringsSep "\n")}
      '')
    ];
    wrapperType = "shell";
    wrapFlags = [
      "--run"
      (throw "FIXME")
      "export TMUX_TMPDIR=$XDG_RUNTIME_DIR"
    ];
  };
}
