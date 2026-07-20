{ pkgs, lib, config, ... }:
let
  inherit (pkgs) writeTextDir;
  vendorConf = "share/fish/vendor_conf.d";

  loadPlugin =
    writeTextDir "${vendorConf}/viper_load.fish"
      # fish
      ''
        function viper_load_plugin
          if test (count $argv) -lt 1
            echo Failed to load plugin, incorrect number of arguments
            return 1
          end
          set -l __plugin_dir $argv[1]/share/fish
          if test -d $__plugin_dir/vendor_functions.d
            set -p fish_function_path $__plugin_dir/vendor_functions.d
          end
          if test -d $__plugin_dir/vendor_completions.d
            set -p fish_complete_path $__plugin_dir/vendor_completions.d
          end
          if test -d $__plugin_dir/vendor_conf.d
            for f in $__plugin_dir/vendor_conf.d/*.fish
              source $f
            end
          end
        end
      '';

  zoxideInit =
    pkgs.runCommand "zoxide-init.fish"
      {
        buildInputs = [ pkgs.zoxide ];
      }
      ''
        zoxide init fish --cmd cd > $out
      '';

  starshipInit = pkgs.runCommand "starship-init.fish" { buildInputs = [ pkgs.starship ]; } ''
    starship init fish > $out
  '';

  # ${lib.concatMapStringsSep "\n" initPlugin plugins}
  cfg =
    writeTextDir "${vendorConf}/viper_config.fish"
      # fish
      ''
        # Only source once
        # set -q __fish_config_sourced; and exit
        # set -gx __fish_config_sourced 1
        ${
          (with pkgs.fishPlugins; [
            foreign-env
            fzf-fish
          ])
          |> (map (elem: "viper_load_plugin ${elem}"))
          |> (lib.concatStringsSep "\n")
        }

        # NixOS's /etc/profile already exits early with __ETC_PROFILE_SOURCED
        # For some reason, status is-login doesn't work consistently
        fenv source /etc/profile

        if status is-interactive
          source ${./interactive.fish}
          source ${./pushd_mod.fish}
          set -gx STARSHIP_CONFIG ${../../../misc/starship.toml}
          function starship_transient_prompt_func
            ${lib.getExe pkgs.starship} module character
          end
          source ${starshipInit}
          enable_transience
          source ${zoxideInit}
        end
      '';
in
{
  wrappers.fish-viper = {
    basePackage = pkgs.fish;
    extraPackages = [ pkgs.zoxide ];
    programs.fish = {
      wrapFlags = [
        "--prefix"
        "XDG_DATA_DIRS"
        ":"
        (lib.makeSearchPathOutput "out" "share" [
          # order matters
          loadPlugin
          cfg
        ])
      ];
    };
  };
}
