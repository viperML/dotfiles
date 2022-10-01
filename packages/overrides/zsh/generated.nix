# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub }:
{
  expand-ealias = {
    pname = "expand-ealias";
    version = "051a1697769b7f74e81d5e376cb330f6394785d8";
    src = fetchFromGitHub ({
      owner = "zigius";
      repo = "expand-ealias.plugin.zsh";
      rev = "051a1697769b7f74e81d5e376cb330f6394785d8";
      fetchSubmodules = false;
      sha256 = "sha256-qTgM2ERFlIH/iSOKnqR/WcCEmuzh/km6bmt20za9jqk=";
    });
    date = "2017-03-10";
  };
  fast-syntax-highlighting = {
    pname = "fast-syntax-highlighting";
    version = "770bcd986620d6172097dc161178210855808ee0";
    src = fetchFromGitHub ({
      owner = "zdharma-continuum";
      repo = "fast-syntax-highlighting";
      rev = "770bcd986620d6172097dc161178210855808ee0";
      fetchSubmodules = false;
      sha256 = "sha256-T4k0pbT7aqLrIRIi2EM15LXCnpRFHzFilAYfRG6kbeY=";
    });
    date = "2022-09-30";
  };
  zsh-autosuggestions = {
    pname = "zsh-autosuggestions";
    version = "a411ef3e0992d4839f0732ebeb9823024afaaaa8";
    src = fetchFromGitHub ({
      owner = "zsh-users";
      repo = "zsh-autosuggestions";
      rev = "a411ef3e0992d4839f0732ebeb9823024afaaaa8";
      fetchSubmodules = false;
      sha256 = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
    });
    date = "2021-06-04";
  };
  zsh-completions = {
    pname = "zsh-completions";
    version = "0.34.0";
    src = fetchFromGitHub ({
      owner = "zsh-users";
      repo = "zsh-completions";
      rev = "0.34.0";
      fetchSubmodules = false;
      sha256 = "sha256-qSobM4PRXjfsvoXY6ENqJGI9NEAaFFzlij6MPeTfT0o=";
    });
  };
  zsh-edit = {
    pname = "zsh-edit";
    version = "4a8fa599792b6d52eadbb3921880a40872013d28";
    src = fetchFromGitHub ({
      owner = "marlonrichert";
      repo = "zsh-edit";
      rev = "4a8fa599792b6d52eadbb3921880a40872013d28";
      fetchSubmodules = false;
      sha256 = "sha256-PI4nvzB/F0mHlc0UZJdD49vjzB6pXhhJYNTSmBhY8iU=";
    });
    date = "2022-05-05";
  };
}
