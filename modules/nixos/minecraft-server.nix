{ config, pkgs, ... }:

{

  networking.firewall.allowedTCPPorts = [ 21 ];
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

  networking.firewall.allowedTCPPortRanges = [{ from = 51000; to = 51999; }];

  users.users.minecraft.initialPassword = "minecraft";

  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
    jvmOpts = "-Xmx1024M -Xms1024M";

    package = (pkgs.papermc.overrideAttrs (prev:
      let
        mcVersion = "1.16.5";
        buildNum = "794";
        jar = builtins.fetchurl {
          url = "https://papermc.io/api/v2/projects/paper/versions/${mcVersion}/builds/${buildNum}/downloads/paper-${mcVersion}-${buildNum}.jar";
          sha256 = "0xlj90mjr759h4hlilhy6l1w6f4jhicbx29bmdwf7k883n2s8zg6";
        };
      in
      {
        version = "${mcVersion}r${buildNum}";
        buildPhase = ''
          cat > minecraft-server << EOF
          #!${pkgs.bash}/bin/sh
          exec ${pkgs.openjdk11_headless}/bin/java \$@ -jar $out/share/papermc/papermc.jar nogui
        '';
        installPhase = ''
          install -Dm444 ${jar} $out/share/papermc/papermc.jar
          install -Dm555 -t $out/bin minecraft-server
        '';
      }

    ));

  };
}
