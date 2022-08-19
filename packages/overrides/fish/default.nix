{
  sources,
  debug ? false,
  #
  makeWrapper,
  makeBinaryWrapper,
  writeText,
  writeTextDir,
  lib,
  fish,
  symlinkJoin,
  #
  fzf,
  starship,
  direnv,
  nix-direnv,
  nix-index,
  exa,
  bat,
  fishPlugins,
  any-nix-shell,
}: let
  myWrapper =
    if debug
    then makeWrapper
    else makeBinaryWrapper;

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

  plugins = with fishPlugins; [
    foreign-env
    fzf-fish
  ];

  direnvConfig = writeTextDir "direnvrc" ''
    source ${nix-direnv}/share/nix-direnv/direnvrc
  '';

  fish_user_config = writeText "user_config.fish" ''
    # Only source once
    set -q __fish_config_sourced; and exit
    set -gx __fish_config_sourced 1

    ${lib.concatMapStringsSep "\n" initPlugin plugins}

    set -gx NIX_AUTO_RUN 0
    function __fish_command_not_found_handler --on-event fish_command_not_found
      echo "FIXME"
    end

    if status is-login
    end

    if status is-interactive
      ${lib.fileContents ./interactive.fish}
      ${lib.fileContents ./pushd_mod.fish}

      set -gx STARSHIP_CONFIG ${./starship.toml}
      ${starship}/bin/starship init fish | source

      echo "working" >> /tmp/fish_sourced

      set -gx direnv_config_dir ${direnvConfig}
      ${direnv}/bin/direnv hook fish | source

      ${any-nix-shell}/bin/any-nix-shell fish | source
    end
  '';

  fish' = fish.overrideAttrs (old: {
    patches = [
      ./fish-on-tmpfs.patch
    ];
    doCheck = false;
    postInstall =
      old.postInstall
      # echo "$(<${fish_user_config})" >> $out/etc/fish/config.fish
      + ''
        echo "source ${fish_user_config}" >> $out/etc/fish/config.fish
      '';
  });

  extraPackages = [
    fzf
    starship
    direnv
    nix-index
    exa
    (symlinkJoin {
      inherit (bat) name pname version;
      paths = [bat];
      buildInputs = [myWrapper];
      postBuild = ''
        wrapProgram $out/bin/bat \
          --add-flags '--theme=ansi' \
          --add-flags '--style=changes,header' \
          --add-flags '--plain' \
          --add-flags '--paging=auto'
      '';
    })
  ];
in
  symlinkJoin {
    name = with fish'; "${pname}-${version}";
    inherit (fish') pname version;
    paths = [fish'] ++ extraPackages;
    nativeBuildInputs = [myWrapper];
    __nocachix = debug;
    postBuild = ''
      wrapProgram $out/bin/fish \
        --set MANPAGER 'sh -c "col -bx | bat --paging=always -l man -p"' \
        --prefix PATH ':' $out/bin \
    '';
  }
