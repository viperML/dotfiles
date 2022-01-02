{ config, pkgs, ... }:

{

  networking.firewall.allowedTCPPorts = [ 21 80 443 ];
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

  # Serve mods via HTTP
  services.nginx = {
    enable = true;
    user = "minecraft";
    group = "minecraft";
    virtualHosts."hetzner.ayats.org" = {
      enableACME = true;
      forceSSL = true;
      root = "/var/lib/minecraft/mods";
    };
  };

  security.acme.certs = {
    "hetzner.ayats.org".email = "ayatsfer@gmail.com";
  };

  networking.firewall.allowedTCPPortRanges = [{ from = 51000; to = 51999; }];

  users.users.minecraft.initialPassword = "minecraft";

  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
    jvmOpts = "-Xmx1536M -Xms512M";

    package = pkgs.mohist-server;
  };
}
