{
  flake.modules.homeManager.terminal =
    {
      config,
      lib,
      inputs,
      ...
    }:
    let
      cfg = config.nyx.terminal.fastfetch;
      top = "#C5E2F7";
      middle = "#92BAD2";
      bottom = "#53789E";
    in
    {
      options.nyx.terminal.fastfetch = {
        enable = lib.mkEnableOption "Fastfetch";
      };

      config = lib.mkIf cfg.enable {
        programs.fastfetch = {
          enable = true;
          settings = {

            logo = {
              source = "${inputs.assets}/icons/cat-ascii.txt";
              # type = "kitty-direct";
              # width = 25;
              padding = {
                left = 2;
                top = 1;
              };
              color = {
                "1" = "#FFFFFF";
              };
            };

            display = {
              separator = "  ";
            };

            modules = [
              "break"
              {
                type = "title";
                format = "{#37}{1}{#37}@{#37}{2}";
                key = "ホスト";
                keyColor = "white";
              }
              "break"
              {
                type = "os";
                key = "╭─";
                keyColor = "${top}";
              }
              {
                type = "kernel";
                key = "├─";
                format = "{1} {2}";
                keyColor = "${top}";
              }
              {
                type = "packages";
                key = "├─󰮯";
                keyColor = "${top}";
              }
              {
                type = "de";
                key = "├─";
                keyColor = "${top}";
              }
              {
                type = "wm";
                key = "├─";
                keyColor = "${top}";
              }
              {
                type = "lm";
                key = "├─󰧨";
                keyColor = "${top}";
              }
              {
                type = "theme";
                key = "├─󰉼";
                keyColor = "${top}";
              }
              {
                type = "icons";
                key = "╰─󰀻";
                keyColor = "${top}";
              }
              "break"
              {
                type = "terminal";
                key = "╭─";
                keyColor = "${middle}";
              }
              {
                type = "terminalfont";
                key = "├─";
                keyColor = "${middle}";
              }
              {
                type = "shell";
                key = "╰─";
                keyColor = "${middle}";
              }
              "break"
              {
                type = "host";
                key = "╭─";
                keyColor = "${bottom}";
              }
              {
                type = "cpu";
                key = "├─󰍛";
                keyColor = "${bottom}";
              }
              {
                type = "gpu";
                key = "├─󰘚";
                keyColor = "${bottom}";
              }
              {
                type = "display";
                key = "├─󰍹";
                keyColor = "${bottom}";
              }
              {
                type = "memory";
                key = "├─󰑭";
                keyColor = "${bottom}";
                format = "{used} / {total}";
              }
              {
                type = "uptime";
                key = "╰─󰅐";
                keyColor = "${bottom}";
              }
              "break"
            ];
          };
        };
      };
    };
}
