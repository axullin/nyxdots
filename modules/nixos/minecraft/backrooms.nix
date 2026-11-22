{
  flake.modules.nixos.minecraft =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.nyx.minecraft;

      modrinth =
        path: sha256:
        pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/${path}";
          inherit sha256;
        };
    in
    {
      options.nyx.minecraft.backrooms.enable = lib.mkEnableOption "the backrooms mod server";

      config = lib.mkIf (cfg.enable && cfg.backrooms.enable) {
        services.minecraft-servers.servers.backrooms = {
          enable = true;
          package = pkgs.fabricServers.fabric-1_20_1.override { loaderVersion = "0.19.5"; };
          openFirewall = true;

          jvmOpts = cfg.jvmFlags;

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

          symlinks.mods = pkgs.linkFarmFromDrvs "mods" (
            builtins.attrValues {
              FabricApi = modrinth "P7dR8mSH/versions/rvI2dfzR/fabric-api-0.92.12%2B1.20.1.jar" "07hwdahmwjrz0bwdbac3aqmvpflzkv2inz16rpycy4xcpm7zz5s1";
              FabricLanguageKotlin = modrinth "Ha28R6CL/versions/s10JMAtS/fabric-language-kotlin-1.10.8%2Bkotlin.1.9.0.jar" "1rypva3fghypxslsrpdijrw9fj288g469bqjy7kir1wcjwifgmw1";
              ClothConfig = modrinth "9s6osm5g/versions/s7VTKfLA/cloth-config-11.1.106-fabric.jar" "0kd3rpl1zw1fkqi1444jhhxnsklkf7r1v3jzp4q8cwzl1pv7m0gs";
              ForgeConfigAPIPort = modrinth "ohNO6lps/versions/HvR3IdRE/ForgeConfigAPIPort-v8.0.3-1.20.1-Fabric.jar" "0yj21rbxpvsv379rgkj87yijnmfhfmm4z3w2varz73m4bdn8yyik";
              PuzzlesLib = modrinth "QAGBst4M/versions/QSW0oJPl/PuzzlesLib-v8.1.36-1.20.1-Fabric.jar" "0b7r4hms6zr2ivncpkvcgqwwhp68x0kla1vfh21x3vak2i5c497d";
              YACL = modrinth "1eAoo2KR/versions/CgwTUAR2/yet-another-config-lib-fabric-3.1.0%2B1.20.jar" "0chpb34y683n8470hya0kw0qrlz323gx9jzhjrnk7jma9jasx5rv";
              Geckolib = modrinth "8BmcQJ2H/versions/SD2lOScS/geckolib-fabric-1.20.1-4.8.4.jar" "19ms6xhq026nkzjvh4argksmyrnsmm78s97gx1ism0vsvfl9b17f";
              Backrooms = modrinth "H6pjI7Ol/versions/UKh0fpwO/spb-revamped-1.20.1-1.1.8.jar" "0j5nhlp7a4r1lap43n5lxnrwsgi463l212q7grkibh84r7ggvw2x";
              HungerRemover = modrinth "Duxl9QUS/versions/B4bwwVAn/hunger-remover-1.0.7.jar" "05hqz7h93dlvyhgyawywrcn1p1h5ia1hndxbkkkv7swk9fy8d190";
              PingWheel = modrinth "QQXAdCzh/versions/ZEvFTc8t/Ping-Wheel-1.12.1-fabric-1.20.1.jar" "06sbhjy0l6h80m09h8w2rpr4wn9jbl5mpcq7kl55iic9kbfkvn5i";
              Debugify = modrinth "QwxR6Gcd/versions/6XDJoCks/Debugify-1.20.1%2B2.0.jar" "17cl6rajjpxkic8zjmddl1a2dlr6q1xh8dw8x5w9b64wc2kph6y6";
              NoChatReports = modrinth "qQyHxfxd/versions/nBoj6rD0/NoChatReports-FABRIC-1.20.1-v2.2.3.jar" "1df7dqiw48a6pdg1a18k4j7ajjij90ah9fx5brzhiz0vk3zyd37v";
              VoiceChat = modrinth "9eGKb6K1/versions/Xb9IEz9H/voicechat-fabric-1.20.1-2.6.24.jar" "1p13ppqy2qsfyhvflg7f75wdzjxlq2l8xpzc1hhrin14na527jyp";
              HorrorMessages = modrinth "dxrOAhj5/versions/19hbrXn8/horrormessages-1.0.1-fabric-1.20.1.jar" "0idgyishks44ykshjrwxfvxgg9nybyg7aw2qyxhcy54nq840jkxm";
            }
          );
        };
      };
    };
}
