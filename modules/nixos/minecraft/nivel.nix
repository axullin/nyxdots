{
  flake.modules.nixos.minecraft =
    {
      config,
      pkgs,
      lib,
      inputs,
      ...
    }:
    let
      cfg = config.nyx.minecraft;

      serverPack = inputs.modpacks.packages.${pkgs.stdenv.hostPlatform.system}.nivel-server;
      serverConfig = "${serverPack.root}/server-config";
    in
    {
      options.nyx.minecraft.nivel.enable = lib.mkEnableOption "the Nivel modpack server";

      config = lib.mkIf (cfg.enable && cfg.nivel.enable) {
        # Simple Voice Chat
        networking.firewall.allowedUDPPorts = [ 24454 ];

        services.minecraft-servers.servers.nivel = {
          openFirewall = true;
          enable = true;
          package = pkgs.fabricServers.fabric-1_21_1.override {
            inherit (serverPack) loaderVersion;
            jre_headless = pkgs.jdk25_headless;
          };

          jvmOpts = cfg.jvmFlags;

          serverProperties = {
            motd = "It's all yours.";
            difficulty = "normal";
            gamemode = "survival";
            view-distance = 10;
            simulation-distance = 8;
            max-players = 8;
            spawn-protection = 0;
            allow-flight = true;
            enable-command-block = false;
            pvp = true;
            online-mode = false;
            level-seed = "";
            level-name = "nibel";
            white-list = false;
          };

          symlinks = {
            mods = "${serverPack}/mods";
            "config/mobcontrol.toml" = "${serverConfig}/mobcontrol.toml";
          };

          files = {
            "config/NoChatReports/NCR-Common.json" = "${serverConfig}/NoChatReports/NCR-Common.json";
            "config/visualjukebox.json" = "${serverConfig}/visualjukebox.json";
            "config/spark/config.json" = "${serverConfig}/spark/config.json";
            "config/xaero" = "${serverConfig}/xaero";
            "nibel/datapacks/nivel-fixes" = "${serverPack.root}/datapacks/nivel-fixes";
          };
        };
      };
    };
}
