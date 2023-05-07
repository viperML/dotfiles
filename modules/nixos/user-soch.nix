{...}: {
  imports = [
    (import ./_mkUser.nix {
      name = "soch";
      uid = 1001;
    })
  ];

  fileSystems."/home/soch" = {
    fsType = "tmpfs";
    device = "none";
    options = [
      "defaults"
      # "size=4G"
      "mode=0755"
    ];
  };
}
