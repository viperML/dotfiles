{ pkgs, ... }:
{
  wrappers.tmux = {
    basePackage = pkgs.tmux;
    flags = [
      "-f"
      (pkgs.writeText "tmux-conf" ''
        source-file ${./tmux.conf}
      '')
    ];
  };
}
