{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 21 ];
  networking.firewall.allowedTCPPortRanges = [{ from = 51000; to = 51999; }];

  # Acess via FTP
  services.vsftpd = {
    enable = true;
    extraConfig = ''
      pasv_enable=Yes
      pasv_min_port=51000
      pasv_max_port=51999
    '';
    writeEnable = true;
    localUsers = true;
    userlist = [ "minecraft" ];
    userlistEnable = true;
  };

  users.users.minecraft.initialPassword = "minecraft";

  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
    jvmOpts = "-Xmx1536M -Xms512M";

    package = pkgs.mohist-server;
  };
}
