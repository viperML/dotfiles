{pkgs, ...}: {
  wrappers.foot = {
    basePackage = pkgs.foot;
    prependFlags = ["--config=${./foot.ini}"];
    postBuild = '' 
      rm -vf $out/share/applications/foot-server.desktop
      rm -vf $out/share/applications/footclient.desktop
    '';
  };
}
