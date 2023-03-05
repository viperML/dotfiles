{
  sources,
  debug ? false,
  #
  zsh,
  symlinkJoin,
  writeTextDir,
  lib,
  makeWrapper,
  makeBinaryWrapper,
  #
  starship,
  fzf,
  direnv,
  nix-direnv,
  nix-index,
  any-nix-shell,
  bat,
  exa,
}: let
  myWrapper =
    if debug
    then makeWrapper
    else makeBinaryWrapper;

  zsh' = zsh.overrideAttrs (old: {
    postInstall = ''
      make install.info install.html
      rm $out/bin/zsh-${old.version}
      mkdir -p $out/share/doc/
      mv $out/share/zsh/htmldoc $out/share/doc/zsh-${old.version}
    '';
    configureFlags = [
      "--enable-maildir-support"
      "--enable-multibyte"
      "--with-tcsetpgrp"
      "--enable-pcre"
      # "--enable-zprofile=${placeholder "out"}/etc/zprofile"
      "--disable-site-fndir"
    ];
  });

  zdotdir = "etc/zdotdir";

  direnvConfig = writeTextDir "direnvrc" ''
    source ${nix-direnv}/share/nix-direnv/direnvrc
  '';

  /*
  `.zshenv' is sourced on all invocations of the shell, unless the -f option is set. It should contain commands to set the command search path, plus other important environment variables. `.zshenv' should not contain commands that produce output or assume the shell is attached to a tty.
  */
  zshenv = writeTextDir "${zdotdir}/.zshenv" ''
    emulate bash
    alias shopt=false
    . /etc/profile
    unalias shopt
    emulate zsh

    export SHELL=$0

    export _NIX_ZSHENV_SOURCED=1
  '';

  /*
  `.zshrc' is sourced in interactive shells. It should contain commands to set up aliases, functions, options, key bindings, etc.
  */
  zshrc = writeTextDir "${zdotdir}/.zshrc" ''
    # Only source this file once
    # if ! [ -z ''${_NIX_ZSHRC_SOURCED+x} ]; then
    #   exit
    # fi

    if [ -z ''${XDG_CACHE_HOME+x} ]; then
        export ZSH_CACHE="''${XDG_CACHE_HOME}/zsh"
    else
        export ZSH_CACHE="''${HOME}/.cache/zsh"
    fi

    if ! mkdir -p "$ZSH_CACHE"; then
        echo "Warning: error creating $ZSH_CACHE"
        export ZSH_CACHE=/tmp
        echo "Setting it to $ZSH_CACHE"
    fi


    typeset -U path cdpath fpath manpath
    fpath+=${sources.zsh-completions.src}/src

    # expand-ealias init
    source ${sources.expand-ealias.src}/expand-ealias.plugin.zsh

    # static config init
    ${lib.fileContents ./rc.zsh}

    # completion init
    ${lib.fileContents ./comp.zsh}

    # Starship init
    export STARSHIP_CONFIG=${../fish/starship.toml}
    eval "$(${starship}/bin/starship init zsh)"

    # Direnv init
    export direnv_config_dir=${direnvConfig}
    eval "$(direnv hook zsh)"

    # command-not-found init
    export NIX_AUTO_RUN=0
    source ${nix-index}/etc/profile.d/command-not-found.sh

    # zsh-autosuggestions init
    export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
    source ${sources.zsh-autosuggestions.src}/zsh-autosuggestions.zsh

    # zsh-edit init
    source ${sources.zsh-edit.src}/zsh-edit.plugin.zsh
    bindkey '^[[1;3A' insert-last-word
    bindkey '^[[1;3B' insert-first-word
    bindkey "^[[1;3C" forward-subword
    bindkey "^[[1;3D" backward-subword

    # fast-syntax-highlighting init
    typeset -gA FAST_BLIST_PATTERNS
    FAST_BLIST_PATTERNS[/mnt/*]=1
    source ${sources.fast-syntax-highlighting.src}/fast-syntax-highlighting.plugin.zsh

    export _NIX_ZSHRC_SOURCED=1
  '';

  /*
  `.zlogin' is sourced in login shells. It should contain commands that should be executed only in login shells.
  */
  zlogin = writeTextDir "${zdotdir}/.zlogin" ''
    export _NIX_ZLOGIN_SOURCED=1
  '';

  /*
  `.zlogout' is sourced when login shells exit.
  */
  zlogout = writeTextDir "${zdotdir}/.zlogout" ''
    :
  '';

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
        set -ex
        wrapProgram $out/bin/bat --add-flags "--theme=ansi --style=changes,header --plain --paging=auto"
        echo test $out/bin/test
        set +ex
      '';
    })
  ];
in
  symlinkJoin {
    name = with zsh; "${pname}-${version}";
    inherit (zsh) pname version;
    paths =
      [
        zsh'
        zshenv
        zshrc
        zlogin
        zlogout
      ]
      ++ extraPackages;
    nativeBuildInputs = [
      myWrapper
    ];
    postBuild = ''
      wrapProgram $out/bin/zsh \
        --set ZDOTDIR $out/${zdotdir} \
        --prefix PATH ':' $out/bin
    '';
  }
