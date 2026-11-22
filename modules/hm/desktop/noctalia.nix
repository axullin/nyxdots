{
  flake.modules.homeManager.desktop =
    {
      pkgs,
      lib,
      config,
      inputs,
      userName,
      ...
    }:
    let
      cfg = config.nyx.desktop.noctalia;

      wallpaperDir = "/home/${userName}/Assets/wallpapers";
      defaultWallpaper = "${wallpaperDir}/waterfall-monochrome.png";
    in
    {
      options.nyx.desktop.noctalia = {
        enable = lib.mkEnableOption "enable the Noctalia desktop shell";
      };

      imports = [ inputs.noctalia.homeModules.default ];

      config = lib.mkIf cfg.enable {
        nyx.impermanence.directories = [
          ".config/noctalia"
          ".local/share/noctalia"
          ".local/state/noctalia"
        ];

        programs.noctalia = {
          enable = true;
          package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
          systemd.enable = true;
          settings = {
            accessibility.ui_scale = 1.35;

            bar.default = {
              background_opacity = 0.65;
              margin_edge = 6;
              margin_ends = 8;
              radius = 6;
              scale = 1.3;
              shadow = false;
              thickness = 45;
              widget_spacing = 8;
            };

            shell = {
              avatar_path = "/home/${userName}/Assets/icons/niko-oneshot.png";
              font_family = "JetBrainsMono NF";
              popup_shadows = false;
              screen_corners = {
                enabled = true;
                size = 16;
              };
              shadow.alpha = 0.0;
            };

            theme = {
              builtin = "";
              community_palette = "";
              pure_black_dark = true;
              source = "wallpaper";
              wallpaper_scheme = "m3-rainbow";
            };

            wallpaper = {
              directory = wallpaperDir;
              transition = [ "wipe" ];
              transition_on_startup = true;
              default.path = defaultWallpaper;
              monitors."DP-1".path = defaultWallpaper;
            };
          };
        };
      };
    };
}
