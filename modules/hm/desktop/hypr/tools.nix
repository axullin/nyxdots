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
