{ config
, pkgs
, lib
, inputs
, ...
}:
{
  home = {
    packages =
      with pkgs; [
        libsForQt5.konsole
      ];

    file.".local/share/konsole/Dracula.colorscheme".source =
      ./Dracula.colorscheme;
    file.".local/share/konsole/Main.profile".source = ./Main.profile;

    activation.konsole = lib.hm.dag.entryAfter [ "writeBoundary" ] (
      inputs.self.lib.x86_64-linux.kde.configsToCommands {
        configs = {
          konsolerc = {
            "Desktop Entry".DefaultProfile = "Main.profile";
            MainWindow = {
              StatusBar = "Disabled";
              RestorePositionForNextInstance = false;
              ToolBarsMovable = false;
            };
            ThumbnailsSettings.ThumbnailShift = true;
            "Notification Messages" = {
              CloseAllEmptyTabs = true;
              CloseAllTabs = true;
              ShowPasteHugeTextWarning = false;
            };
          };
        };
      }
    );
  };
}
