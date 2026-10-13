{
  flake.modules.nixos.networking =
    {
      config,
      pkgs,
      lib,
      inputs,
      ...
    }:
    let
      cfg = config.nyx.networking.mc-server;
      clientFiles = inputs.nix-minecraft.lib.collectFilesAt pkgs.nivel-modpack-client;

      # Everything under defaults/ is what AutoModpack publishes, from
      # automodpack/host-modpack/main.
      defaults = ../../../pkgs/minecraft/modpack/defaults;
      clientDefaults = {
        "automodpack/host-modpack/main/options.txt" = defaults + "/options.txt";
      };

      # A symlink to the config directory is not walked. Each file has to be
      # its own symlink, same as the mod jars, or it never enters the content list.
      configFiles = lib.mapAttrs' (name: file: {
        name = "automodpack/host-modpack/main/${name}";
        value = file;
      }) (inputs.nix-minecraft.lib.collectFilesAt defaults "config");

      hostModpack = lib.mapAttrs' (name: file: {
        name = "automodpack/host-modpack/main/${name}";
        value = file;
      }) (clientFiles "mods" // clientFiles "resourcepacks" // clientFiles "shaderpacks");
    in
    {
      imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

      options.nyx.networking.mc-server = {
        enable = lib.mkEnableOption "Enable the minecraft server";

        dataDir = lib.mkOption {
          type = lib.types.str;
          description = "Directory that holds the world and server files.";
        };

        jvmOpts = lib.mkOption {
          type = lib.types.str;
          description = "JVM options for the server, including the heap size.";
        };
      };

      config = lib.mkIf cfg.enable {
        systemd.services.minecraft-server-nivel.unitConfig.RequiresMountsFor = cfg.dataDir;

        networking.firewall.allowedUDPPorts = [ 24454 ];

        services.minecraft-servers = {
          enable = true;
          eula = true;
          inherit (cfg) dataDir;

          servers = {
            nivel = {
              enable = true;
              # Loader pinned to what the pack declares, read from pack.toml, so
              # a nixpkgs bump cannot drift the server off the pack's loader.
              package = pkgs.fabricServers.fabric-1_21_1.override {
                loaderVersion = pkgs.nivel-modpack-server.loaderVersion;
              };
              openFirewall = true;

              inherit (cfg) jvmOpts;

              serverProperties = {
                motd = "It's all yours.";
                difficulty = "normal";
                gamemode = "survival";
                view-distance = 14;
                simulation-distance = 8;
                max-players = 8;
                spawn-protection = 0;
                allow-flight = true;
                enable-command-block = false;
                pvp = true;
                online-mode = false;
                level-seed = "that's_la_peace2137";
                level-name = "jupiii";
                white-list = false;
              };

              symlinks = {
                mods = "${pkgs.nivel-modpack-server}/mods";
              }
              // hostModpack
              // configFiles
              // clientDefaults;
            };
          };
        };
      };
    };
}
