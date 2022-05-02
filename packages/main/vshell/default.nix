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
}: let
  myFishPlugins = [
    rec {
      name = "fzf.fish";
      src = fetchFromGitHub {
        repo = name;
        owner = "PatrickF1";
        rev = "fdc1f4043b1ff4da76bb7c0a6a4f19084e9213ef";
        sha256 = "1m5gqnjmm0gm906mrhl54pwmjpqfbjims7zvjk4hyhyx45hi94m8";
      };
    }
    rec {
      name = "sponge";
      src = fetchFromGitHub {
        repo = name;
        owner = "andreiborisov";
        rev = "0f3bf8f10b81b25d2b3bbb3d6ec86f77408c0908";
        sha256 = "0vsi872c58z7zzdr0kzfsx49fi7241dakjdp6h1ff3wfzw2zsi0i";
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

  fish-conf = writeTextFile {
    name = "config.fish";
    executable = false;
    text = ''
      set -q __fish_home_manager_config_sourced; and exit
      set -g __fish_home_manager_config_sourced 1


      set --prepend fish_function_path ${fishPlugins.foreign-env}/share/fish/vendor_functions.d
      ${any-nix-shell}/bin/any-nix-shell fish | source
      ${direnv}/bin/direnv hook fish | source
      ${lib.concatMapStringsSep "\n" (init: "source ${init}") fishPluginsInits}

      status --is-interactive; and begin
        ${starship}/bin/starship init fish | source
        ${lib.fileContents ./interactive.fish}
        ${lib.fileContents ./pushd-mod.fish}
      end
    '';
  };

  myBat = symlinkJoin {
    inherit (bat) name meta;
    paths = [bat];
    buildInputs = [makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/bat \
        --add-flags "--theme=ansi --style=changes,header --plain --paging=auto"
    '';
  };

  runtimeDeps = [
    myBat
    exa
    fd
    fzf
    any-nix-shell
  ];
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
