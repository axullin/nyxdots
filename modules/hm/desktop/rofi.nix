{
  flake.modules.homeManager.desktop =
    {
      lib,
      config,
      inputs,
      ...
    }:
    let
      wallpaper = "${inputs.assets}/wallpapers/waterfall.png";

      palette = ''
        * {
            background:      #1e1e2ee6;
            background-alt:  #313244ff;
            foreground:      #cdd6f4ff;
            selected:        #cba6f7ff;
            active:          #a6e3a1ff;
            urgent:          #a38ba8ff;
        }
      '';
    in
    lib.mkIf (!config.nyx.desktop.noctalia.enable) {
      programs.rofi = {
        enable = true;
        font = "JetBrainsMono Nerd Font 16";
        theme = "launcher";
        extraConfig = {
          modi = "drun,filebrowser,window";
          show-icons = true;
          drun-display-format = "{name}";
          display-drun = "";
          display-filebrowser = "";
          display-window = "";
          window-format = "{w} · {c} · {t}";
        };
      };

      xdg.dataFile."rofi/themes/launcher.rasi".text = ''
        ${palette}

        window {
            transparency:        "real";
            location:            center;
            anchor:              center;
            border:              3px;
            border-color:        @foreground;
            fullscreen:          false;
            width:               1064px;
            enabled:             true;
            border-radius:       40px 7px 40px 7px;
            cursor:              "default";
            background-color:    @background;
        }

        mainbox {
            enabled:             true;
            spacing:             0px;
            background-color:    transparent;
            orientation:         vertical;
            children:            [ "inputbar", "listbox" ];
        }

        listbox {
            spacing:             27px;
            padding:             27px;
            background-color:    transparent;
            orientation:         vertical;
            border:              3px 0px 0px 0px;
            border-color:        @foreground;
            children:            [ "message", "listview" ];
        }

        inputbar {
            enabled:             true;
            spacing:             13px;
            padding:             133px 80px;
            background-color:    transparent;
            background-image:    url("${wallpaper}", width);
            text-color:          @foreground;
            orientation:         horizontal;
            children:            [ "textbox-prompt-colon", "entry", "dummy", "mode-switcher" ];
        }
        textbox-prompt-colon {
            enabled:             true;
            expand:              false;
            str:                 "";
            padding:             16px 20px;
            border-radius:       20px 7px 20px 7px;
            background-color:    @background-alt;
            text-color:          inherit;
            size:                53px;
        }
        entry {
            enabled:             true;
            expand:              false;
            width:               332px;
            padding:             16px 21px;
            border-radius:       7px 20px 7px 20px;
            background-color:    @background-alt;
            text-color:          inherit;
            cursor:              text;
            placeholder:         "Search";
            placeholder-color:   inherit;
        }
        dummy {
            expand:              true;
            background-color:    transparent;
        }

        mode-switcher {
            enabled:             true;
            spacing:             13px;
            background-color:    transparent;
            text-color:          @foreground;
        }
        button {
            width:               60px;
            padding:             16px;
            border-radius:       20px 7px 20px 7px;
            background-color:    @background-alt;
            text-color:          inherit;
            cursor:              pointer;
        }
        button selected {
            background-color:    @selected;
            text-color:          @foreground;
        }

        listview {
            enabled:             true;
            columns:             2;
            lines:               6;
            cycle:               true;
            dynamic:             true;
            scrollbar:           false;
            layout:              vertical;
            reverse:             false;
            fixed-height:        true;
            fixed-columns:       true;
            spacing:             13px;
            background-color:    transparent;
            text-color:          @foreground;
            cursor:              "default";
        }

        element {
            enabled:             true;
            spacing:             13px;
            padding:             16px;
            border-radius:       20px 7px 20px 7px;
            background-color:    transparent;
            text-color:          @foreground;
            cursor:              pointer;
        }
        element normal.normal {
            background-color:    inherit;
            text-color:          inherit;
        }
        element normal.urgent {
            background-color:    @urgent;
            text-color:          @foreground;
        }
        element normal.active {
            background-color:    @active;
            text-color:          @foreground;
        }
        element selected.normal {
            background-color:    @selected;
            text-color:          @background;
        }
        element selected.urgent {
            background-color:    @urgent;
            text-color:          @foreground;
        }
        element selected.active {
            background-color:    @urgent;
            text-color:          @foreground;
        }
        element-icon {
            background-color:    transparent;
            text-color:          inherit;
            size:                43px;
            cursor:              inherit;
        }
        element-text {
            background-color:    transparent;
            text-color:          inherit;
            cursor:              inherit;
            vertical-align:      0.5;
            horizontal-align:    0.0;
        }

        message {
            background-color:    transparent;
        }
        textbox {
            padding:             16px;
            border-radius:       20px 7px 20px 7px;
            background-color:    @background-alt;
            text-color:          @foreground;
            vertical-align:      0.5;
            horizontal-align:    0.0;
        }
        error-message {
            padding:             16px;
            border-radius:       0px;
            background-color:    @background;
            text-color:          @foreground;
        }
      '';
    };
}
