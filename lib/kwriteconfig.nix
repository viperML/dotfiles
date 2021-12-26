{ lib, ... }:

with builtins;
{
  kdeToString = { configs }: lib.flatten (lib.mapAttrsToList
    (file: groups:
      lib.mapAttrsToList
        (group: keys:
          lib.mapAttrsToList
            (key: value:
              "test -f ~/.config/'${file}' && ${pkgs.libsForQt5.kconfig}/bin/kwriteconfig5 --file ~/.config/'${file}' --group '${group}' --key '${key}' '${
                toValue value
              }'")
            keys)
        groups)
    configs);
}
