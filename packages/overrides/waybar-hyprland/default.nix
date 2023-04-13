# https://github.com/hyprwm/Hyprland/blob/4bc3f9adbe7563817a9e1c6eac6f5e435f7db957/flake.nix#L90
{waybar}:
waybar.overrideAttrs (oldAttrs: {
  postPatch = ''
    # use hyprctl to switch workspaces
    sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
  '';
  mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
})
