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
        ssh
        virtualisation
        printing3d
      ];

      nyx = {
        desktop = {
          hyprland.enable = true;
          davinci-resolve.enable = true;
        };

        hardware.amdgpu.enable = true;

        ai.ollama.enable = true;

        printing3d.enable = true;

        gaming.aagl = {
          enable = true;
          "anime-game-launcher".enable = true;
        };

        boot = {
          cachyosKernel.enable = true;
          secure-boot.enable = true;
          silent-boot.enable = true;

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

                # Nix
                ".cache/nix"

                # Browsers
                ".config/BraveSoftware"
                ".config/zen"
                ".mozilla/firefox"

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
                ".config/unity3d"
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
                ".config/opencode"
                ".local/share/opencode"
                ".local/state/opencode"
                ".local/share/nvim"
                ".local/state/nvim"

                # Media
                ".config/kdenlive"
                ".local/share/kdenlive"
                ".local/share/krita"
                ".config/obs-studio"
                ".cache/spotify"
                ".cache/spotify-player"

                # Audio device selection
                ".local/state/wireplumber"

                # 3D modeling / printing
                ".config/blender"
                ".config/FreeCAD"
                ".local/share/FreeCAD"
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
                ".config/kdenliverc"
              ];
            };
          };
        };

        networking.mc-server = {
          enable = false;
          dataDir = "/mnt/storage/minecraft";
          jvmOpts = "-Xmx8G -Xms8G";
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
