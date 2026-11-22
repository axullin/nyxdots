{
  flake.modules.homeManager.printing3d =
    {
      pkgs,
      lib,
      config,
      osConfig,
      ...
    }:
    let
      cfg = config.nyx.printing3d;

      # Temporary fix for the broken data directories in bambuddy
      bambuddyWrapped = pkgs.writeShellApplication {
        name = "bambuddy";
        text = ''
          export DATA_DIR="''${DATA_DIR:-$HOME/.local/share/bambuddy/data}"
          export LOG_DIR="''${LOG_DIR:-$HOME/.local/share/bambuddy/logs}"
          mkdir -p "$DATA_DIR" "$LOG_DIR"
          exec ${lib.getExe pkgs.bambuddy} "$@"
        '';
      };
    in
    {
      options.nyx.printing3d = {
        enable = lib.mkEnableOption "3D printing apps (Bambu Studio, Bambuddy)" // {
          default = osConfig.nyx.printing3d.enable or false;
        };
      };

      config = lib.mkIf cfg.enable {
        nyx.impermanence.directories = [
          ".config/BambuStudio"
          ".local/share/bambuddy"
        ];

        home.packages = [
          pkgs.bambu-studio
          bambuddyWrapped
        ];
      };
    };
}
