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

    export HISTFILE="$XDG_CACHE_HOME/zsh-histfile"
    export HISTSIZE=10000
    export SAVEHIST=10000

    export SHELL=$0
    expot MANPAGER "sh -c 'col -bx | bat --paging=always -l man -p'"

    export _NIX_ZSHENV_SOURCED=1
  '';

  /*
  `.zshrc' is sourced in interactive shells. It should contain commands to set up aliases, functions, options, key bindings, etc.
  */
  zshrc = writeTextDir "${zdotdir}/.zshrc" ''
    if [[ -z _NIX_ZSHRC_SOURCED ]]; then; exit; fi
    typeset -U path cdpath fpath manpath

    fpath=(${sources.zsh-completions.src}/src $fpath)

    ${lib.fileContents ./rc.zsh}

    ${lib.fileContents ./comp.zsh}


    export STARSHIP_CONFIG=${./starship.toml}
    eval "$(${starship}/bin/starship init zsh)"

    export direnv_config_dir=${direnvConfig}
    eval "$(direnv hook zsh)"

    export NIX_AUTO_RUN=0
    source ${nix-index}/etc/profile.d/command-not-found.sh

    ${any-nix-shell}/bin/any-nix-shell zsh | source /dev/stdin

    export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    source ${sources.zsh-autosuggestions.src}/zsh-autosuggestions.zsh


    # Last one
    source ${sources.zsh-syntax-highlighting.src}/zsh-syntax-highlighting.zsh
    # After syntax
    source ${sources.zsh-history-substring-search.src}/zsh-history-substring-search.zsh
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
    bat
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
    __nocachix = debug;
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
