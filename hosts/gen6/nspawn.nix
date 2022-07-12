{...}: {
  systemd.nspawn."fc36" = {
    networkConfig = {
      Private = false;
    };
    filesConfig = {
      BindReadOnly = "/etc/resolv.conf";
      PrivateUsersChown = true;
    };
    execConfig = {
      Boot = true;
      ResolvConf = "off";
      PrivateUsers = true;
    };
  };
}
