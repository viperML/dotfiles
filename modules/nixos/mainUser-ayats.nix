{
  config,
  pkgs,
  inputs,
  packages,
  ...
}: let
  name = "ayats";
  home = "/home/ayats";
in {
  users.mutableUsers = false;

  users.users.mainUser = {
    inherit name home;
    createHome = true;
    description = "Fernando Ayats";
    isNormalUser = true;
    extraGroups = [
      "audio"
      "input"
      "networkmanager"
      "systemd-journal"
      "uucp"
      "video"
      "wheel"
    ];
  };

  security.sudo.extraRules = [
    {
      groups = ["wheel"];
      commands = [
        {
          command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
          options = ["SETENV" "NOPASSWD"];
        }
        {
          command = "${packages.nh.nh}/bin/nh";
          options = ["SETENV" "NOPASSWD"];
        }
      ];
    }
  ];

  services.xserver.displayManager.autoLogin.user = name;
}
