{
  imports = [
    (import ./_mkUser.nix "soch")
  ];

  users.users.soch = {
    uid = 10001;
    home = "/tmp/soch";
  };
}
