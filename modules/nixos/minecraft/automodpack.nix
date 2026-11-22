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

      packages = inputs.modpacks.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      options.nyx.minecraft.nivel.automodpack.enable =
        lib.mkEnableOption "handing out the Nivel client pack through AutoModpack"
        // {
          default = true;
        };

      config = lib.mkIf (cfg.enable && cfg.nivel.enable && cfg.nivel.automodpack.enable) {
        services.minecraft-servers.servers.nivel.files = {
          "automodpack/server.conf" = packages.nivel-automodpack-conf;
          "automodpack/host-modpack" = packages.nivel-host-modpack;
        };
      };
    };
}
