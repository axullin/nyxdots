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
      cfg = config.nyx.networking;
    in
    {
      imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

      options.nyx.networking.mc-server = {
        enable = lib.mkEnableOption "Enable the minecraft server";
      };

      config = lib.mkIf cfg.mc-server.enable {

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
              package = pkgs.fabricServers.fabric-1_21_1;
              openFirewall = true;

              jvmOpts = "-Xmx8G -Xms8G";

              serverProperties = {
                motd = "おやすみ, おやすみ, close your eyes and you'll leave this dream...";
                difficulty = "normal";
                gamemode = "survival";
                level-type = "terraforged";
                view-distance = 14;
                simulation-distance = 8;
                max-players = 5;
                spawn-protection = 0;
                allow-flight = true;
                enable-command-block = false;
                pvp = true;
                online-mode = true;
                level-seed = "IAmAJollyOldChappy";
                level-name = "world";
                white-list = true;
              };

              # Mods: packwiz-managed pack (pkgs.nivel-modpack)
              symlinks.mods = pkgs.symlinkJoin {
                name = "mods";
                paths = [
                  "${pkgs.nivel-modpack}/mods"
                ];
              };

              symlinks.shaderpacks = pkgs.linkFarm "shaderpacks" {
                "Bliss_v2.1.2.zip" = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/ZvMtQlho/versions/kC2Y8q1P/Bliss_v2.1.2_%28Chocapic13_Shaders_edit%29.zip";
                  sha512 = "dafc60be4980ec40f40edc0f2625cb0976f3c9ce5ed86383146a120480826bb1de70ef5e38b7f1437294ed4d38c6ef3c82ebef0ae4e00b8cee165788c9c18280";
                };
                "MakeUp-UltraFast-9.5c.zip" = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/izsIPI7a/versions/zt4eHisU/MakeUp-UltraFast-9.5c.zip";
                  sha512 = "67d3938a1ad27ee0951b63703cd638b9db36bcf92c66dfe7ffff4c01ac365e952bbf630af1bb5bbddde8a723e7fb287e88bf80fe0301c70f12b4ebe8546c7947";
                };
              };

              symlinks.resourcepacks = pkgs.linkFarm "resourcepacks" {
                "Enchanted.zip" = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/QvkCB0QE/versions/TCaZMjsR/Enchanted.zip";
                  sha512 = "04ac87a094a357ea74ed7e06c66664d3ac6b6377bef388ef0a4b826010301e0a8fb885ab7f622af8209cdf6d591a92537c4234c1f6e82875f87b01c0fd0d4a32";
                };
                "VanillaTweaks.zip" = pkgs.vanillatweaks;
              };
            };
          };
        };
      };
    };
}
