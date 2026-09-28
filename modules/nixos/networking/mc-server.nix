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
      clientFiles = inputs.nix-minecraft.lib.collectFilesAt pkgs.nivel-modpack-client;

      hostModpack = lib.mapAttrs' (name: file: {
        name = "automodpack/host-modpack/main/${name}";
        value = file;
      }) (clientFiles "mods" // clientFiles "resourcepacks" // clientFiles "shaderpacks");
    in
    {
      imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

      options.nyx.networking.mc-server = {
        enable = lib.mkEnableOption "Enable the minecraft server";
      };

      config = lib.mkIf config.nyx.networking.mc-server.enable {

        # TODO: change the datadir and server enablement into per host options
        systemd.services.minecraft-server-nivel.unitConfig.RequiresMountsFor = "/mnt/storage";

        networking.firewall.allowedUDPPorts = [ 24454 ];

        services.minecraft-servers = {
          enable = true;
          eula = true;
          dataDir = "/mnt/storage/minecraft";

          servers = {
            nivel = {
              enable = true;
              # Loader pinned to what the pack declares, read from pack.toml, so
              # a nixpkgs bump cannot drift the server off the pack's loader.
              package = pkgs.fabricServers.fabric-1_21_1.override {
                loaderVersion = pkgs.nivel-modpack-server.loaderVersion;
              };
              openFirewall = true;

              jvmOpts = "-Xmx8G -Xms8G";

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
                online-mode = true;
                level-seed = "-2243532794236063784";
                level-name = "worldier";
                white-list = false;
              };

              symlinks = {
                mods = "${pkgs.nivel-modpack-server}/mods";
              }
              // hostModpack;
            };
          };
        };
      };
    };
}
