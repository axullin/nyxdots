{
  flake.modules.nixos.proxnix =
    { inputs, ... }:
    {
      imports = [ inputs.disko.nixosModules.disko ];

      disko.devices.disk.main = {
        type = "disk";
        device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [
                  "-f"
                  "--label"
                  "proxnix"
                ];
                mountpoint = "/";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                  "discard=async"
                ];
              };
            };
          };
        };
      };
    };
}
