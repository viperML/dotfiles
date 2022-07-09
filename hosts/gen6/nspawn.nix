{...}: {
  systemd.nspawn = {
    "fc36" = {
      networkConfig = {
        VirtualEthernet = false;
      };
      filesConfig = {
        BindReadOnly = [
          "/etc/resolv.conf"
        ];
      };
      execConfig = {
        Environment = [
          "PATH=/usr/bin:/usr/sbin"
        ];
        ResolvConf = "off";
      };
    };
  };
}
