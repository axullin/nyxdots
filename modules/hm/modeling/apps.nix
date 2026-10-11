{
  flake.modules.homeManager.modeling =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.nyx.modeling;
    in
    {
      options.nyx.modeling = {
        enable = lib.mkEnableOption "3D modeling apps (Blender, FreeCAD)";
      };

      config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
          blender
          # unstable's freecad 1.1.4 has no Hydra build; stable 1.1.3 is cached.
          stable.freecad
        ];
      };
    };
}
