{
  pkgs,
  lib,
  ...
}:
with builtins; {
  configsToCommands = let
    toValue = v:
      if builtins.isString v
      then v
      else if builtins.isBool v
      then lib.boolToString v
      else if builtins.isInt v
      then builtins.toString v
      else builtins.abort ("Unknown value type: " ++ builtins.toString v);
  in
    {configs}:
      builtins.concatStringsSep "\n" (lib.flatten (lib.mapAttrsToList (file: groups:
        lib.mapAttrsToList (group: keys:
          lib.mapAttrsToList (
            key: value: "test -f ~/.config/'${file}' && ${pkgs.libsForQt5.kconfig}/bin/kwriteconfig5 --file ~/.config/'${
              file
            }' --group '${
              group
            }' --key '${
              key
            }' '${
              toValue value
            }'"
          )
          keys)
        groups)
      configs));
}
