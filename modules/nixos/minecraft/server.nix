{
  flake.modules.nixos.minecraft =
    {
      config,
      lib,
      inputs,
      ...
    }:
    let
      cfg = config.nyx.minecraft;

      # Aikar's G1 flags
      gcFlags = lib.concatStringsSep " " [
        "-XX:+UseG1GC"
        "-XX:+ParallelRefProcEnabled"
        "-XX:MaxGCPauseMillis=200"
        "-XX:+UnlockExperimentalVMOptions"
        "-XX:+DisableExplicitGC"
        "-XX:+AlwaysPreTouch"
        "-XX:G1NewSizePercent=30"
        "-XX:G1MaxNewSizePercent=40"
        "-XX:G1HeapRegionSize=8M"
        "-XX:G1ReservePercent=20"
        "-XX:G1HeapWastePercent=5"
        "-XX:G1MixedGCCountTarget=4"
        "-XX:InitiatingHeapOccupancyPercent=15"
        "-XX:G1MixedGCLiveThresholdPercent=90"
        "-XX:G1RSetUpdatingPauseTimePercent=5"
        "-XX:SurvivorRatio=32"
        "-XX:+PerfDisableSharedMem"
        "-XX:MaxTenuringThreshold=1"
      ];
    in
    {
      imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

      options.nyx.minecraft = {
        enable = lib.mkEnableOption "the Minecraft servers";

        dataDir = lib.mkOption {
          type = lib.types.str;
          description = "Directory every server lives in";
        };

        jvmOpts = lib.mkOption {
          type = lib.types.str;
          description = "JVM options for the servers";
        };

        jvmFlags = lib.mkOption {
          type = lib.types.str;
          readOnly = true;
          internal = true;
          default = "${cfg.jvmOpts} ${gcFlags}";
          description = "jvmOpts plus the GC flags, for each server's jvmOpts";
        };
      };

      config = lib.mkIf cfg.enable {
        services.minecraft-servers = {
          enable = true;
          eula = true;
          inherit (cfg) dataDir;
        };

        systemd.services = lib.mapAttrs' (
          name: _:
          lib.nameValuePair "minecraft-server-${name}" { unitConfig.RequiresMountsFor = cfg.dataDir; }
        ) (lib.filterAttrs (_: server: server.enable) config.services.minecraft-servers.servers);
      };
    };
}
