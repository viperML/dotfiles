{
  config,
  lib,
  ...
}: let
  inherit (config.lib) gvariant;
in {
  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" =
      (builtins.listToAttrs (map (number: lib.nameValuePair "switch-to-workspace-${number}" (gvariant.mkArray gvariant.type.string ["<Super>${number}"])) (map builtins.toString (lib.range 1 9))))
      // (builtins.listToAttrs (map (number: lib.nameValuePair "move-to-workspace-${number}" (gvariant.mkArray gvariant.type.string ["<Super><Shift>${number}"])) (map builtins.toString (lib.range 1 9))));
    "org/gnome/shell/keybindings" = builtins.listToAttrs (map (number: lib.nameValuePair "switch-to-application-${number}" (gvariant.mkArray gvariant.type.string [])) (map builtins.toString (lib.range 1 9)));
  };
}
