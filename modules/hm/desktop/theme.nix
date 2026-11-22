{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      nyx.impermanence.directories = [ ".config/dconf" ];

      home.pointerCursor = {
        enable = true;
        name = "Bibata-Original-Classic";
        size = 28;
        package = pkgs.bibata-cursors;
        gtk.enable = true;
        x11.enable = true;
      };

      # What is going on with this option
      # It is so bad
      qt = {
        enable = true;
        style.name = "adwaita-dark";
      };

      gtk = {
        enable = true;
        font = {
          name = "DejaVu Sans";
          size = 13;
        };
        theme = {
          name = "adw-gtk3-dark";
          package = pkgs.adw-gtk3;
        };
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };
      };

      dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };
}
