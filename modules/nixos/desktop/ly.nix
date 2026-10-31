{
  flake.modules.nixos.desktop = {
    services.displayManager = {
      ly = {
        enable = true;
        settings = {
          session_log = "null";
          clear_password = true;
          allow_empty_password = true;
          corner_top_left = "";
          corner_top_right = "";
          corner_bottom_left = "";
          xinitrc = null;
          hide_borders = true;
        };
      };
    };
  };
}
