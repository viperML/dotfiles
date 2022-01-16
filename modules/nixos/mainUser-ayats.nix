{ config, pkgs, ... }:

{
  users.mutableUsers = false; # change passwords of users

  users.users.mainUser = {
    name = "ayats";
    # initialPassword = "1234";
    createHome = true;
    home = "/home/ayats";
    description = "Fernando Ayats";
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "uucp" "systemd-journal" "networkmanager" ];
    passwordFile = "/secrets/password/ayats";
  };

  # programs.ssh.startAgent = true;
  # security.sudo.wheelNeedsPassword = false;
  security.sudo = {
    extraRules = [
      {
        groups = [ "wheel" ];
        commands = [
          {
            command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
            options = [ "SETENV" "NOPASSWD" ];
          }
        ];
      }
    ];
    extraConfig =
      let
        my-lecture = pkgs.writeTextFile {
          name = "my-lecture";
          text = ''

            [?7l[1m[34m      \\  \\ //
            [34m     ==\\__\\/ //
            [34m       //   \\//
            [34m    ==//     //==
            [34m     //\\___//
            [34m    // /\\  \\==
            [34m      // \\  \\

            [0m [[ you have angered the nix gods]]

          '';
        };
      in
      ''
        Defaults lecture=always
        Defaults lecture_file=${my-lecture}
      '';
  };

  # users.users = mkMerge (
  #   [{ root.passwordFile = "/secrets/password/root"; }] ++
  #   forEach config.users (u:
  #     { "${u}".passwordFile = "/secrets/password/${u}"; }
  #   )
  # );
}
