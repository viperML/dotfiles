{ stdenv
, bash
, jdk11_headless
, lib
}:
let
  mcVersion = "1.16.5";
  revision = "904";

  jar = builtins.fetchurl {
    url = "https://mohistmc.com/builds/${mcVersion}/mohist-${mcVersion}-${revision}-server.jar";
    sha256 = "0w3y9h764ys21ynzslm3f5hp4za7ngws5sjc3v33clqargs0gs9a";
  };

  my_java = jdk11_headless;
in
stdenv.mkDerivation {
  pname = "mohist-server";
  version = "${mcVersion}r${revision}";

  preferLocalBuild = true;
  dontUnpack = true;
  dontConfigure = true;

  buildPhase = ''
    cat > minecraft-server << EOF
    #!${bash}/bin/sh
    cp $out/share/mohist-server/mohist-server.jar .
    exec ${my_java}/bin/java \$@ -jar mohist-server.jar
  '';

  installPhase = ''
    install -Dm444 ${jar} $out/share/mohist-server/mohist-server.jar
    install -Dm555 -t $out/bin minecraft-server
  '';

  meta = {
    description = "Minecraft Forge Server Software Implementing Paper/Spigot/Bukkit API";
    homepage = "https://mohistmc.com/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    # maintainers = with lib.maintainers; [ aaronjanse neonfuz ];
  };
}
