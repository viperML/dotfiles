{
  git,
  runCommand,
  makeBinaryWrapper,
  lib,
  writeText,
  lndir,
  #
  delta,
  gh,
  git-extras,
  glab,
}: let
  gitconfig = writeText "gitconfig" (lib.fileContents ./gitconfig);

  extraPrograms = [
    git-extras
    delta
  ];
in
  runCommand "git" {
    inherit (git) pname version;
    inherit git extraPrograms;
    passAsFile = ["extraPrograms"];
    nativeBuildInputs = [
      makeBinaryWrapper
    ];
  } ''
    mkdir -p $out
    ${lndir}/bin/lndir -silent $git $out

    rm -r $out/bin
    mkdir -p $out/bin

    # ls to remove the prefix
    for program in $(ls $git/bin); do
      makeWrapper $git/bin/$program $out/bin/$program \
        --set GIT_CONFIG_GLOBAL ${gitconfig}
    done

    for dir in $(<$extraProgramsPath); do
      ${lndir}/bin/lndir -silent "$dir" "$out"
    done
  ''
