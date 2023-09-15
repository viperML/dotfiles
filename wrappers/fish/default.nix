{packages}: {
  pkgs,
  lib,
  ...
}: {
  _file = ./default.nix;
  wrappers.fish = {
    pathAdd = [
      pkgs.fzf
      pkgs.starship
      pkgs.direnv
      packages.nix-index
      pkgs.eza
      packages.any-nix-shell
      packages.bat
    ];

    env.MANPAGER = "'sh -c \"col -bx | bat --paging=always -l man -p\"'";

    basePackage = let
      initPlugin = plugin: ''
        begin
          set -l __plugin_dir ${plugin}/share/fish
          if test -d $__plugin_dir/vendor_functions.d
            set -p fish_function_path $__plugin_dir/vendor_functions.d
          end
          if test -d $__plugin_dir/vendor_completions.d
            set -p fish_complete_path $__plugin_dir/vendor_completions.d
          end
          if test -d $__plugin_dir/vendor_conf.d
            for f in $plugin_dir/vendor_conf.d/*.fish
              source $f
            end
          end
        end
      '';
      plugins = with pkgs.fishPlugins; [
        foreign-env
        fzf-fish
      ];
      direnvConfig = pkgs.writeTextDir "direnvrc" ''
        source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc
      '';
      fish_user_config = pkgs.writeText "user_config.fish" ''
        # Only source once
        # set -q __fish_config_sourced; and exit
        # set -gx __fish_config_sourced 1
        ${lib.concatMapStringsSep "\n" initPlugin plugins}
        fenv source /etc/profile
        source ${packages.nix-index}/share/fish/vendor_functions.d/nix-index.fish
        if status is-login
        end
        if status is-interactive
          ${lib.fileContents ./interactive.fish}
          ${lib.fileContents ./pushd_mod.fish}
          set -gx STARSHIP_CONFIG ${../starship.toml}
          function starship_transient_prompt_func
            starship module character
          end
          ${pkgs.starship}/bin/starship init fish | source
          enable_transience
          set -gx DIRENV_LOG_FORMAT ""
          set -gx direnv_config_dir ${direnvConfig}
          ${pkgs.direnv}/bin/direnv hook fish | source
        end
      '';
    in
      pkgs.fish.overrideAttrs (old: {
        patches = [
          ./fish-on-tmpfs.patch
        ];
        doCheck = false;
        postInstall =
          old.postInstall
          + ''
            echo "source ${fish_user_config}" >> $out/etc/fish/config.fish
          '';
      });
  };
}
