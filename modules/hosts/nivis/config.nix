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
        networking
        virtualisation
        printing3d
      ];

      nyx = {
        desktop = {
          hyprland.enable = true;
        };

        hardware.nvidia.enable = true;

        printing3d.enable = true;

        gaming.aagl = {
          enable = true;
          "anime-game-launcher".enable = true;
        };

        boot = {
          cachyosKernel.enable = true;
          secure-boot.enable = true;

          impermanence = {
            enable = true;

            files = [
              "/etc/machine-id"
              "/etc/ly/save.txt"
            ];

            home = {
              directories = [
                # Credentials
                ".local/share/keyrings"

                # This flake's location
                ".config/nixos"

                # Browsers
                ".config/BraveSoftware"
                ".config/zen"

                # Discord
                ".config/discord"
                ".config/Vencord"

                # Notes / flashcards
                ".config/anki"
                ".local/share/Anki2"
                ".config/obsidian"

                # Gaming
                ".steam"
                ".local/share/Steam"
                ".local/share/osu"
                ".local/share/Celeste"
                ".config/Olympus"
                ".local/share/PrismLauncher"
                ".local/share/anime-game-launcher"

                # Arduino IDE
                ".arduino15"
                ".config/arduino-ide"

                # Editors / AI tooling
                ".cursor"
                ".config/cursor"
                ".local/share/nvim"
                ".local/state/nvim"

                # Media
                ".local/share/krita"
                ".config/obs-studio"
                ".cache/spotify-player"

                # 3D modeling / printing
                ".config/blender"
                ".config/FreeCAD"
                ".local/share/FreeCAD"
                ".config/OrcaSlicer"
                ".config/BambuStudio"
                ".local/share/bambuddy"

                # Peripherals
                ".config/OpenTabletDriver"
                ".config/wootility"

                # Desktop shell and dconf
                ".config/noctalia"
                ".local/share/noctalia"
                ".local/state/noctalia"
                ".cache/awww"
                ".config/dconf"

                # Shell
                ".local/share/fish"
                ".config/gh"
                ".config/kotofetch"
              ];

              files = [
                # Add files if necesarry
              ];
            };
          };
        };

        networking.mc-server.enable = true;
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
