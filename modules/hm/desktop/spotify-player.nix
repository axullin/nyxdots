{
  flake.modules.homeManager.desktop = {
    programs.spotify-player = {
      enable = true;
      settings = {
        client_id = "eec673bd8161458eb3271107561f7436";
        theme = "monochrome-dark";
        border_type = "Hidden";
        cover_img_display_protocol = "None";
        cover_img_length = 22;
        cover_img_width = 10;
        cover_img_scale = 0.9;
        playback_window_position = "Top";
        progress_bar_type = "Rectangle";
        copy_command = {
          command = "wl-copy";
          args = [ ];
        };

        device = {
          volume = 100;
          bitrate = 320;
          normalization = false;
        };
      };

      themes = [
        {
          name = "monochrome-dark";
          palette = {
            background = "#000000";
            foreground = "#ffffff";
            selection_background = "#ffffff";
            selection_foreground = "#000000";

            black = "#000000";
            white = "#ffffff";
            red = "#e0e0e0";
            green = "#e5e5e5";
            yellow = "#888888";
            blue = "#cccccc";
            magenta = "#e0e0e0";
            cyan = "#ffffff";

            bright_black = "#888888";
            bright_white = "#ffffff";
            bright_red = "#ffffff";
            bright_green = "#b2b2b2";
            bright_yellow = "#ffffff";
            bright_blue = "#ffffff";
            bright_magenta = "#ffffff";
            bright_cyan = "#ffffff";
          };
        }
      ];
    };
  };
}
