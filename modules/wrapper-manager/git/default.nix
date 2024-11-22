{ pkgs, inputs', ... }:
let
  myGit = pkgs.gitFull;
in
{
  wrappers.git = {
    # basePackage = inputs'.git-args.packages.default.override {
    #   git = myGit;
    # };
    basePackage = myGit;
    extraPackages = [
      pkgs.git-extras
      myGit
    ];
    env.GIT_CONFIG_GLOBAL.value = ../../../misc/gitconfig;
    env.GIT_CLONE_FLAGS.value = "--recursive --filter=blob:none";
  };
}
