{
  # Wrapping
  fetchFromGitHub,
  lib,
  makeWrapper,
  runCommandNoCC,
  symlinkJoin,
  writeText,
  writeTextFile,
  # Runtime deps
  fish,
  any-nix-shell,
  fishPlugins,
  starship,
  bat,
  exa,
  fd,
  fzf,
  direnv,
  nix-index,
  bash,
  writeScript,
  nix-autobahn,
  writeTextDir,
  nix-direnv,
}: let
  myFishPlugins = [
    rec {
      name = "fzf.fish";
      src = fetchFromGitHub {
        repo = "fzf.fish";
        owner = "PatrickF1";
        rev = "6d8e962f3ed84e42583cec1ec4861d4f0e6c4eb3";
        sha256 = "0lv2gl9iylllqp9v0wqib3rll2ii1sm2xkjfzlqhybvkhbrdvffj";
      };
    }
    rec {
      name = "sponge";
      src = fetchFromGitHub {
        repo = "sponge";
        owner = "andreiborisov";
        rev = "dcfcc9089939f48b25b861a9254a39de8e9f33a0";
        sha256 = "1nx9hkjjvscxkphi8ipg5iyplvrxg4xs5c6mkwyb07z15wa9yqgq";
      };
    }
  ];

  myFish = fish.overrideAttrs (prev: {
    doCheck = false;
    patches = (prev.patches or []) ++ [./fish-on-tmpfs.patch];
  });

  fishPluginsInits = map (plugin:
    writeText plugin.name ''
      # Plugin ${plugin.name}
      set -l plugin_dir ${plugin.src}
      # Set paths to import plugin components
      if test -d $plugin_dir/functions
        set fish_function_path $fish_function_path[1] $plugin_dir/functions $fish_function_path[2..-1]
      end
      if test -d $plugin_dir/completions
        set fish_complete_path $fish_complete_path[1] $plugin_dir/completions $fish_complete_path[2..-1]
      end
      # Source initialization code if it exists.
      if test -d $plugin_dir/conf.d
        for f in $plugin_dir/conf.d/*.fish
          source $f
        end
      end
      if test -f $plugin_dir/key_bindings.fish
        source $plugin_dir/key_bindings.fish
      end
      if test -f $plugin_dir/init.fish
        source $plugin_dir/init.fish
      end
    '')
  myFishPlugins;

  nix-index-wrapper = writeScript "command-not-found" ''
    #!${bash}/bin/bash
    source ${nix-index}/etc/profile.d/command-not-found.sh
    command_not_found_handle "$@"
  '';

  direnvrc = writeTextDir "direnvrc" ''
    source ${nix-direnv}/share/nix-direnv/direnvrc
  '';

  direnv-config = symlinkJoin {
    name = "direnv-config";
    paths = [direnvrc];
  };

  fish-conf = writeTextFile {
    name = "config.fish";
    executable = false;
    text = ''
      set -q __fish_home_manager_config_sourced; and exit
      set -g __fish_home_manager_config_sourced 1


      set --prepend fish_function_path ${fishPlugins.foreign-env}/share/fish/vendor_functions.d

      ${any-nix-shell}/bin/any-nix-shell fish | source

      set -g direnv_config_dir ${direnv-config}
      ${direnv}/bin/direnv hook fish | source


      ${lib.concatMapStringsSep "\n" (init: "source ${init}") fishPluginsInits}

      status --is-interactive; and begin
        ${starship}/bin/starship init fish | source
        ${lib.fileContents ./interactive.fish}
        ${lib.fileContents ./pushd-mod.fish}
      end

      function __fish_command_not_found_handler --on-event fish_command_not_found
        ${nix-index-wrapper} $argv
      end
    '';
  };

  myWrappers = [
    (symlinkJoin {
      inherit (bat) name;
      paths = [bat];
      buildInputs = [makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/bat \
          --add-flags "--theme=ansi --style=changes,header --plain --paging=auto"
      '';
    })
  ];

  runtimeDeps =
    [
      exa
      fd
      fzf
      any-nix-shell
      direnv
      nix-index
      nix-autobahn
    ]
    ++ myWrappers;
in
  symlinkJoin {
    name = "vshell";
    inherit (myFish) meta;
    paths = [myFish];
    buildInputs = [makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/fish \
        --set STARSHIP_CONFIG ${./starship.toml} \
        --set MANPAGER "sh -c 'col -bx | bat --paging=always -l man -p'" \
        --prefix PATH : ${lib.makeBinPath runtimeDeps} \
        --add-flags '-C "source ${fish-conf}"'
    '';
  }
