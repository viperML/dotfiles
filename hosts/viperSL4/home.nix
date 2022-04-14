{
  pkgs,
  config,
  ...
}: let
  vscode-remote-wsl-nixos = pkgs.fetchFromGitHub {
    owner = "sonowz";
    repo = "vscode-remote-wsl-nixos";
    rev = "e5dded6ee6e214fbf14a88f58775334ca5c19571";
    sha256 = "1am3hw0m72qvb7lxfzv6c4l6srsrxvvhf9xcpg7v8sga855vihsi";
  };
in {
  home.packages = with pkgs; [
    wget
    (pkgs.writeShellScriptBin "ssh" ''
      ssh.exe "$@"
    '')
  ];

  systemd.user.tmpfiles.rules = builtins.map (d: "L+ ${config.home.homeDirectory}/${d} - - - - /mnt/c/Users/${config.home.username}/${d}") [
    "Desktop"
    "Documents"
    "Downloads"
    "Music"
    "Pictures"
    "Videos"
  ];

  home.file.".vscode-server/server-env-setup".source = ./server-env-setup;
}
