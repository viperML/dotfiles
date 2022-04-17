{
  discord-canary,
  symlinkJoin,
  makeWrapper,
  lib,
  xdg-utils,
}:
symlinkJoin {
  name = "discordcanary";
  paths = [discord-canary];
  buildInputs = [makeWrapper];
  postBuild = ''
    wrapProgram $out/bin/discordcanary \
      --prefix PATH : ${lib.makeBinPath [xdg-utils]}
  '';
}
