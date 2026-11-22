{ config, ... }:
{
  flake.modules.nixos.nivis =
    { hostName, ... }:
    {
      imports = with config.flake.modules.nixos; [
        boot
        desktop
        gaming
        hardware
        ai
        networking
        minecraft
        ssh
        virtualisation
        printing3d
      ];

      nyx = {
        desktop = {
          hyprland.enable = true;
          davinci-resolve = {
            enable = true;
            studio = true;
            aacFix = true;
            extraCommands = "";
          };
        };

        hardware.amdgpu.enable = true;
        hardware.zram.enable = true;

        ai.ollama.enable = false;

        printing3d.enable = true;

        gaming.aagl = {
          enable = true;
          "anime-game-launcher".enable = true;
        };

        boot = {
          cachyosKernel.enable = true;
          secure-boot.enable = true;
          silent-boot.enable = true;
        };

        impermanence.enable = true;

        minecraft = {
          enable = false;
          dataDir = "/mnt/storage/minecraft";
          jvmOpts = "-Xmx8G -Xms8G";
          nivel.enable = true;
        };
      };

      networking = {
        inherit hostName;
        networkmanager.enable = true;
      };

      fileSystems."/mnt/storage" = {
        device = "/dev/disk/by-uuid/26dd8624-a605-7944-9671-99dcd58f79fc";
        fsType = "btrfs";
        options = [
          "noatime"
          "compress=zstd"
          "nofail"
        ];
      };

      system.stateVersion = "25.11";
    };
}
