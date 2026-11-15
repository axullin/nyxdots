{
  flake.modules.nixos.nivis =
    { inputs, ... }:
    {
      imports = [ inputs.disko.nixosModules.disko ];

      disko.devices = {
        disk = {
          # /boot — p4, vfat 1G
          boot = {
            device = "/dev/disk/by-uuid/0CFE-86A6";
            type = "disk";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          # NixOS btrfs — p6, 135G
          nixos = {
            device = "/dev/disk/by-uuid/8619ee23-2e5e-493f-84a6-13f64f2df347";
            type = "disk";
            content = {
              type = "btrfs";
              extraArgs = [
                "-f"
                "--label"
                "nixos"
              ];
              subvolumes = {
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "@persist" = {
                  mountpoint = "/persist";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
              };
            };
          };
        };

        # Ephemeral root — wiped on every reboot
        nodev."/" = {
          fsType = "tmpfs";
          mountOptions = [
            "defaults"
            "size=16G"
            "mode=755"
          ];
        };
      };
    };
}
