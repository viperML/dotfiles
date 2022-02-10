# This patch changes the titlebar to native
# https://forum.obsidian.md/t/add-option-to-enable-disable-frameless-mode/6991/18
{ obsidian
, nodePackages
, gnused
}:
obsidian.overrideAttrs (
  prev: {
    patchPhase = ''
      ${nodePackages.asar}/bin/asar extract resources/obsidian.asar resources/obsidian
      rm resources/obsidian.asar
      ${gnused}/bin/sed -i 's/frame: false/frame: true/' resources/obsidian/main.js
      ${nodePackages.asar}/bin/asar pack resources/obsidian resources/obsidian.asar
      rm -rf resources/obsidian
    '';
  }
)
