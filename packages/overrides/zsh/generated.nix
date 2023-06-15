# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  expand-ealias = {
    pname = "expand-ealias";
    version = "051a1697769b7f74e81d5e376cb330f6394785d8";
    src = fetchFromGitHub {
      owner = "zigius";
      repo = "expand-ealias.plugin.zsh";
      rev = "051a1697769b7f74e81d5e376cb330f6394785d8";
      fetchSubmodules = false;
      sha256 = "sha256-qTgM2ERFlIH/iSOKnqR/WcCEmuzh/km6bmt20za9jqk=";
    };
    date = "2017-03-10";
  };
  fast-syntax-highlighting = {
    pname = "fast-syntax-highlighting";
    version = "13d7b4e63468307b6dcb2dadf6150818f242cbff";
    src = fetchFromGitHub {
      owner = "zdharma-continuum";
      repo = "fast-syntax-highlighting";
      rev = "13d7b4e63468307b6dcb2dadf6150818f242cbff";
      fetchSubmodules = false;
      sha256 = "sha256-AmsexwVombgVmRvl4O9Kd/WbnVJHPTXETxBv18PDHz4=";
    };
    date = "2023-04-03";
  };
  zsh-autosuggestions = {
    pname = "zsh-autosuggestions";
    version = "a411ef3e0992d4839f0732ebeb9823024afaaaa8";
    src = fetchFromGitHub {
      owner = "zsh-users";
      repo = "zsh-autosuggestions";
      rev = "a411ef3e0992d4839f0732ebeb9823024afaaaa8";
      fetchSubmodules = false;
      sha256 = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
    };
    date = "2021-06-04";
  };
  zsh-completions = {
    pname = "zsh-completions";
    version = "0.34.0";
    src = fetchFromGitHub {
      owner = "zsh-users";
      repo = "zsh-completions";
      rev = "0.34.0";
      fetchSubmodules = false;
      sha256 = "sha256-qSobM4PRXjfsvoXY6ENqJGI9NEAaFFzlij6MPeTfT0o=";
    };
  };
  zsh-edit = {
    pname = "zsh-edit";
    version = "9eb286982f96f03371488e910e42afb23802bdfd";
    src = fetchFromGitHub {
      owner = "marlonrichert";
      repo = "zsh-edit";
      rev = "9eb286982f96f03371488e910e42afb23802bdfd";
      fetchSubmodules = false;
      sha256 = "sha256-LVHkH7fi8BQxLSeV+osdZzar1PQ0/hdb4yZ4oppGBoc=";
    };
    date = "2023-06-13";
  };
}
