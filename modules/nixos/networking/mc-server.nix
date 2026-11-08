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

      defaults = "${inputs.modpacks}/nivel/defaults";
      serverConfig = "${inputs.modpacks}/nivel/server-config";
      clientDefaults = {
        "automodpack/host-modpack/main/options.txt" = defaults + "/options.txt";
      };

      configFiles = lib.mapAttrs' (name: file: {
        name = "automodpack/host-modpack/main/${name}";
        value = file;
      }) (inputs.nix-minecraft.lib.collectFilesAt defaults "config");

      hostModpack = lib.mapAttrs' (name: file: {
        name = "automodpack/host-modpack/main/${name}";
        value = file;
      }) (clientFiles "mods" // clientFiles "resourcepacks" // clientFiles "shaderpacks");

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

      options.nyx.networking.mc-server = {
        enable = lib.mkEnableOption "Enable the minecraft server";

        dataDir = lib.mkOption {
          type = lib.types.str;
          description = "Server directory";
        };

        jvmOpts = lib.mkOption {
          type = lib.types.str;
          description = "JVM options for the server";
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
              openFirewall = true;
              enable = true;
              package = pkgs.fabricServers.fabric-1_21_1.override {
                loaderVersion = pkgs.nivel-modpack-server.loaderVersion;
              };

              jvmOpts = "${cfg.jvmOpts} ${gcFlags}";

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
                mods = "${pkgs.nivel-modpack-server}/mods";
                "config/mobcontrol.toml" = serverConfig + "/mobcontrol.toml";
              }
              // hostModpack
              // configFiles
              // clientDefaults;

              files = {
                "config/NoChatReports/NCR-Common.json" = serverConfig + "/NoChatReports/NCR-Common.json";
                "config/xaero" = serverConfig + "/xaero";
                "nibel/datapacks/nivel-fixes" = "${inputs.modpacks}/nivel/datapacks/nivel-fixes";
              };
            };

            backrooms = {
              enable = false;
              package = pkgs.fabricServers.fabric-1_20_1.override { loaderVersion = "0.19.5"; };
              openFirewall = true;

              jvmOpts = "${cfg.jvmOpts} ${gcFlags}";

              serverProperties = {
                motd = "A server made for playing the backrooms mod";
                difficulty = "normal";
                gamemode = "survival";
                view-distance = 14;
                simulation-distance = 10;
                max-players = 2;
                spawn-protection = 0;
                allow-flight = true;
                enable-command-block = false;
                pvp = true;
                online-mode = true;
                level-name = "bagrums";
                white-list = false;
              };

              symlinks = {
                mods = pkgs.linkFarmFromDrvs "mods" (
                  builtins.attrValues {
                    FabricApi = pkgs.fetchurl {
                      url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/rvI2dfzR/fabric-api-0.92.12%2B1.20.1.jar";
                      sha256 = "07hwdahmwjrz0bwdbac3aqmvpflzkv2inz16rpycy4xcpm7zz5s1";
                    };
                    FabricLanguageKotlin = pkgs.fetchurl {
                      url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/s10JMAtS/fabric-language-kotlin-1.10.8%2Bkotlin.1.9.0.jar";
                      sha256 = "1rypva3fghypxslsrpdijrw9fj288g469bqjy7kir1wcjwifgmw1";
                    };
                    ClothConfig = pkgs.fetchurl {
                      url = "https://cdn.modrinth.com/data/9s6osm5g/versions/s7VTKfLA/cloth-config-11.1.106-fabric.jar";
                      sha256 = "0kd3rpl1zw1fkqi1444jhhxnsklkf7r1v3jzp4q8cwzl1pv7m0gs";
                    };
                    ForgeConfigAPIPort = pkgs.fetchurl {
                      url = "https://cdn.modrinth.com/data/ohNO6lps/versions/HvR3IdRE/ForgeConfigAPIPort-v8.0.3-1.20.1-Fabric.jar";
                      sha256 = "0yj21rbxpvsv379rgkj87yijnmfhfmm4z3w2varz73m4bdn8yyik";
                    };
                    PuzzlesLib = pkgs.fetchurl {
                      url = "https://cdn.modrinth.com/data/QAGBst4M/versions/QSW0oJPl/PuzzlesLib-v8.1.36-1.20.1-Fabric.jar";
                      sha256 = "0b7r4hms6zr2ivncpkvcgqwwhp68x0kla1vfh21x3vak2i5c497d";
                    };
                    YACL = pkgs.fetchurl {
                      url = "https://cdn.modrinth.com/data/1eAoo2KR/versions/CgwTUAR2/yet-another-config-lib-fabric-3.1.0%2B1.20.jar";
                      sha256 = "0chpb34y683n8470hya0kw0qrlz323gx9jzhjrnk7jma9jasx5rv";
                    };
                    Geckolib = pkgs.fetchurl {
                      url = "https://cdn.modrinth.com/data/8BmcQJ2H/versions/SD2lOScS/geckolib-fabric-1.20.1-4.8.4.jar";
                      sha256 = "19ms6xhq026nkzjvh4argksmyrnsmm78s97gx1ism0vsvfl9b17f";
                    };
                    Backrooms = pkgs.fetchurl {
                      url = "https://cdn.modrinth.com/data/H6pjI7Ol/versions/UKh0fpwO/spb-revamped-1.20.1-1.1.8.jar";
                      sha256 = "0j5nhlp7a4r1lap43n5lxnrwsgi463l212q7grkibh84r7ggvw2x";
                    };
                    HungerRemover = pkgs.fetchurl {
                      url = "https://cdn.modrinth.com/data/Duxl9QUS/versions/B4bwwVAn/hunger-remover-1.0.7.jar";
                      sha256 = "05hqz7h93dlvyhgyawywrcn1p1h5ia1hndxbkkkv7swk9fy8d190";
                    };
                    PingWheel = pkgs.fetchurl {
                      url = "https://cdn.modrinth.com/data/QQXAdCzh/versions/ZEvFTc8t/Ping-Wheel-1.12.1-fabric-1.20.1.jar";
                      sha256 = "06sbhjy0l6h80m09h8w2rpr4wn9jbl5mpcq7kl55iic9kbfkvn5i";
                    };
                    Debugify = pkgs.fetchurl {
                      url = "https://cdn.modrinth.com/data/QwxR6Gcd/versions/6XDJoCks/Debugify-1.20.1%2B2.0.jar";
                      sha256 = "17cl6rajjpxkic8zjmddl1a2dlr6q1xh8dw8x5w9b64wc2kph6y6";
                    };
                    NoChatReports = pkgs.fetchurl {
                      url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/nBoj6rD0/NoChatReports-FABRIC-1.20.1-v2.2.3.jar";
                      sha256 = "1df7dqiw48a6pdg1a18k4j7ajjij90ah9fx5brzhiz0vk3zyd37v";
                    };
                    VoiceChat = pkgs.fetchurl {
                      url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/Xb9IEz9H/voicechat-fabric-1.20.1-2.6.24.jar";
                      sha256 = "1p13ppqy2qsfyhvflg7f75wdzjxlq2l8xpzc1hhrin14na527jyp";
                    };
                    HorrorMessages = pkgs.fetchurl {
                      url = "https://cdn.modrinth.com/data/dxrOAhj5/versions/19hbrXn8/horrormessages-1.0.1-fabric-1.20.1.jar";
                      sha256 = "0idgyishks44ykshjrwxfvxgg9nybyg7aw2qyxhcy54nq840jkxm";
                    };
                  }
                );
              };
            };
          };
        };
      };
    };
}
