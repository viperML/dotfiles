{
  zsh,
  makeBinaryWrapper,
  symlinkJoin,
  writeTextDir,
  lib,
  #
  sources,
  starship,
  fzf,
  bat
}: let
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

    export _NIX_ZSHENV_SOURCED=1
  '';

  /*
  `.zshrc' is sourced in interactive shells. It should contain commands to set up aliases, functions, options, key bindings, etc.
  */
  zshrc = writeTextDir "${zdotdir}/.zshrc" ''
    typeset -U path cdpath fpath manpath

    fpath=(${sources.zsh-completions.src}/src $fpath)

    ${lib.fileContents ./rc.zsh}

    ${lib.fileContents ./comp.zsh}


    export STARSHIP_CONFIG=${./starship.toml}
    eval "$(${starship}/bin/starship init zsh)"

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
      # Can get overriden
      makeBinaryWrapper
    ];
    postBuild = ''
      wrapProgram $out/bin/zsh \
        --set ZDOTDIR $out/${zdotdir} \
        --prefix PATH ':' $out/bin
    '';
  }
