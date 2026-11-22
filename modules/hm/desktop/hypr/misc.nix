{
  flake.modules.homeManager.desktop =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.nyx.desktop.hyprland;
    in
    {
      options.nyx.desktop.hyprland = {
        enable = lib.mkEnableOption "Enable Hyprland";
      };

      config = lib.mkIf cfg.enable {
        nyx.impermanence.directories = [ ".cache/awww" ];

        home.packages = with pkgs; [
          hyprpicker
          hyprshot
          wl-clipboard
          clipse
          awww
        ];
      };
    };
}
