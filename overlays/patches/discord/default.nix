{
  discord,
  fetchurl,
  nodePackages,
}: let
  betterdiscord-asar =
    fetchurl {
      url = "https://github.com/BetterDiscord/BetterDiscord/releases/download/v1.5.1/betterdiscord.asar";
      sha256 = "1n3488i72l7mw856klymx31639b5067hslhi0y5bhsks4k074pwy";
    };
in
  discord.overrideAttrs (
    prev: {
      postPatch = ''
        set -x
        pushd resources
        ${nodePackages.asar}/bin/asar extract app.asar extract
        rm app.asar

        echo 'module.exports = require("./core.asar");' >> extract/app_bootstrap/index.js
        cp -a ${betterdiscord-asar} extract/app_bootstrap/core.asar


        ${nodePackages.asar}/bin/asar pack extract app.asar
        rm -rf extract

        ls
        popd
        set +x
        # exit 1
      '';
    }
  )
