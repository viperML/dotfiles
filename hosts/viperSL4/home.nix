{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    wget
    # (pkgs.writeShellScriptBin "ssh" ''
    #   ssh.exe "$@"
    # '')
  ];

  systemd.user.tmpfiles.rules = builtins.map (d: "L+ ${config.home.homeDirectory}/${d} - - - - /mnt/c/Users/${config.home.username}/${d}") [
    "Desktop"
    "Documents"
    "Downloads"
    "Music"
    "Pictures"
    "Videos"
  ];
}
