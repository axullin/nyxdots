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
        enable = lib.mkEnableOption "3D modeling apps";
      };

      config = lib.mkIf cfg.enable {
        nyx.impermanence.directories = [ ".config/blender" ];

        home.packages = with pkgs; [
          blender
        ];
      };
    };
}
