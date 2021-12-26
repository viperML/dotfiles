# lib

Utility functions.

## kde


### configsToCommands

Generates `kwriteconfigs` commands to set values via activation scripts.

Takes a an attribute set as argument such as:
```nix
{
  configs = {
    konsolerc = {
      TabBar = {
        TabBarPosition = "Bottom";
        ExpandTabWidth = false;
      };
    };
  };
}
```

And returns a string such as:
```nix
''
test -f ~/.config/konsolerc && /nix/store/.../bin/kwriteconfig5 --file ~/.config/konsolerc --group 'TabBar' --key 'TabBarPosition' 'Bottom'
test -f ~/.config/konsolerc && /nix/store/.../bin/kwriteconfig5 --file ~/.config/konsolerc --group 'TabBar' --key 'ExpandTabWidth' 'false'
''
```

You can use the output directly in in `home-manager`, for example:
```nix
{ inputs, lib, ...}:

{
  home.activation.<activation script name> = lib.hm.dag.entryAfter [ "writeBoundary" ]
    (inputs.viperml.lib.kde.configsToCommands {
      configs = {
        konsolerc = {
          TabBar = {
            TabBarPosition = "Bottom";
            ExpandTabWidth = false;
          };
        };
      };
    });
}
```
