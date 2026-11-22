{
  flake.modules.homeManager.desktop =
    {
      lib,
      config,
      osConfig,
      ...
    }:
    let
      cfg = config.nyx.desktop.hyprland;
      inherit (lib.generators) mkLuaInline;

      mod = "SUPER";
      terminal = "kitty";
      launcher =
        if config.nyx.desktop.noctalia.enable then
          "noctalia msg panel-toggle launcher"
        else
          "rofi -show drun";

      # Workspace focus/move binds for keys 1-9, 0 (mirrors Hyprland's usual `key % 10` mapping).
      workspaceBinds = lib.concatMap (
        i:
        let
          key = toString (lib.mod i 10);
        in
        [
          {
            _args = [
              "${mod} + ${key}"
              (mkLuaInline "hl.dsp.focus({ workspace = ${toString i} })")
            ];
          }
          {
            _args = [
              "${mod} + SHIFT + ${key}"
              (mkLuaInline "hl.dsp.window.move({ workspace = ${toString i} })")
            ];
          }
        ]
      ) (lib.range 1 10);
    in
    {
      options.nyx.desktop.hyprland = {
        enable = lib.mkEnableOption "the Hyprland user config" // {
          default = osConfig.nyx.desktop.hyprland.enable or false;
        };
      };

      config = lib.mkIf cfg.enable {
        wayland.windowManager.hyprland = {
          enable = true;
          xwayland.enable = true;
          configType = "lua";

          settings = {
            monitor = {
              output = "DP-1";
              mode = "2560x1440@360";
              position = "auto";
              scale = 1;
            };

            config = {
              general = {
                gaps_in = 8;
                gaps_out = 10;
                border_size = 0;
                "col.active_border" = "rgba(b2b2b2ff)";
                "col.inactive_border" = "rgba(00000000)";
                layout = "dwindle";
                allow_tearing = true;
              };
              decoration = {
                active_opacity = 1.0;
                inactive_opacity = 1.0;
                rounding = 5;
                shadow.enabled = true;
                blur = {
                  enabled = true;
                  size = 3;
                  passes = 3;
                  new_optimizations = true;
                };
              };
              input = {
                kb_layout = "pl";
                follow_mouse = 1;
                accel_profile = "flat";
                force_no_accel = true;
                sensitivity = 0;
                repeat_rate = 30;
                repeat_delay = 300;
              };
              misc = {
                force_default_wallpaper = 0;
                disable_hyprland_logo = true;
                vrr = 0;
              };
              cursor = {
                enable_hyprcursor = false;
                no_hardware_cursors = true;
              };
              xwayland.force_zero_scaling = false;
              debug.vfr = false;
              animations.enabled = true;
            };

            curve = {
              _args = [
                "easeOutQuint"
                {
                  type = "bezier";
                  points = [
                    [
                      0.23
                      1
                    ]
                    [
                      0.32
                      1
                    ]
                  ];
                }
              ];
            };

            animation = [
              {
                leaf = "windows";
                enabled = true;
                speed = 3;
                bezier = "easeOutQuint";
              }
              {
                leaf = "layers";
                enabled = true;
                speed = 2;
                bezier = "default";
                style = "fade";
              }
              {
                leaf = "border";
                enabled = true;
                speed = 5;
                bezier = "default";
              }
              {
                leaf = "fade";
                enabled = true;
                speed = 3;
                bezier = "default";
              }
              {
                leaf = "workspaces";
                enabled = true;
                speed = 3;
                bezier = "default";
                style = "slide";
              }
            ];

            on = {
              _args = [
                "workspace.created"
                (mkLuaInline ''
                  function(ws)
                    if ws.name ~= "special:music" then return end
                    if not ws.is_empty then return end
                    hl.exec_cmd("kitty -e spotify_player", { workspace = ws.name .. " silent" })
                  end
                '')
              ];
            };

            bind = [
              {
                _args = [
                  "${mod} + H"
                  (mkLuaInline ''hl.dsp.focus({ direction = "left" })'')
                ];
              }
              {
                _args = [
                  "${mod} + L"
                  (mkLuaInline ''hl.dsp.focus({ direction = "right" })'')
                ];
              }
              {
                _args = [
                  "${mod} + K"
                  (mkLuaInline ''hl.dsp.focus({ direction = "up" })'')
                ];
              }
              {
                _args = [
                  "${mod} + J"
                  (mkLuaInline ''hl.dsp.focus({ direction = "down" })'')
                ];
              }

              {
                _args = [
                  "${mod} + SHIFT + H"
                  (mkLuaInline ''hl.dsp.window.move({ direction = "left" })'')
                ];
              }
              {
                _args = [
                  "${mod} + SHIFT + L"
                  (mkLuaInline ''hl.dsp.window.move({ direction = "right" })'')
                ];
              }
              {
                _args = [
                  "${mod} + SHIFT + K"
                  (mkLuaInline ''hl.dsp.window.move({ direction = "up" })'')
                ];
              }
              {
                _args = [
                  "${mod} + SHIFT + J"
                  (mkLuaInline ''hl.dsp.window.move({ direction = "down" })'')
                ];
              }

              {
                _args = [
                  "${mod} + Q"
                  (mkLuaInline ''hl.dsp.exec_cmd("${terminal}")'')
                ];
              }
              {
                _args = [
                  "${mod} + D"
                  (mkLuaInline ''hl.dsp.exec_cmd("${launcher}")'')
                ];
              }

              {
                _args = [
                  "${mod} + C"
                  (mkLuaInline "hl.dsp.window.close()")
                ];
              }
              {
                _args = [
                  "${mod} + V"
                  (mkLuaInline ''hl.dsp.window.float({ action = "toggle" })'')
                ];
              }
              {
                _args = [
                  "${mod} + F"
                  (mkLuaInline "hl.dsp.window.fullscreen()")
                ];
              }

              {
                _args = [
                  "${mod} + Escape"
                  (mkLuaInline ''hl.dsp.exec_cmd("loginctl lock-session")'')
                ];
              }

              {
                _args = [
                  "${mod} + M"
                  (mkLuaInline ''hl.dsp.workspace.toggle_special("music")'')
                ];
              }
            ]
            ++ workspaceBinds
            ++ [
              {
                _args = [
                  "${mod} + equal"
                  (mkLuaInline "hl.dsp.window.resize({ x = 40, y = 0, relative = true })")
                  { repeating = true; }
                ];
              }
              {
                _args = [
                  "${mod} + minus"
                  (mkLuaInline "hl.dsp.window.resize({ x = -40, y = 0, relative = true })")
                  { repeating = true; }
                ];
              }

              {
                _args = [
                  "${mod} + mouse:272"
                  (mkLuaInline "hl.dsp.window.drag()")
                  { mouse = true; }
                ];
              }
              {
                _args = [
                  "${mod} + mouse:273"
                  (mkLuaInline "hl.dsp.window.resize()")
                  { mouse = true; }
                ];
              }

              {
                _args = [
                  "XF86AudioRaiseVolume"
                  (mkLuaInline ''hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 1%+")'')
                  {
                    locked = true;
                    repeating = true;
                  }
                ];
              }
              {
                _args = [
                  "XF86AudioLowerVolume"
                  (mkLuaInline ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-")'')
                  {
                    locked = true;
                    repeating = true;
                  }
                ];
              }
              {
                _args = [
                  "XF86AudioMute"
                  (mkLuaInline ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")'')
                  { locked = true; }
                ];
              }
              {
                _args = [
                  "XF86AudioMicMute"
                  (mkLuaInline ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")'')
                  { locked = true; }
                ];
              }

              {
                _args = [
                  "XF86MonBrightnessUp"
                  (mkLuaInline ''hl.dsp.exec_cmd("brightnessctl s 10%+")'')
                  {
                    locked = true;
                    repeating = true;
                  }
                ];
              }
              {
                _args = [
                  "XF86MonBrightnessDown"
                  (mkLuaInline ''hl.dsp.exec_cmd("brightnessctl s 10%-")'')
                  {
                    locked = true;
                    repeating = true;
                  }
                ];
              }

              {
                _args = [
                  "XF86AudioNext"
                  (mkLuaInline ''hl.dsp.exec_cmd("playerctl next")'')
                  { locked = true; }
                ];
              }
              {
                _args = [
                  "XF86AudioPause"
                  (mkLuaInline ''hl.dsp.exec_cmd("playerctl play-pause")'')
                  { locked = true; }
                ];
              }
              {
                _args = [
                  "XF86AudioPlay"
                  (mkLuaInline ''hl.dsp.exec_cmd("playerctl play-pause")'')
                  { locked = true; }
                ];
              }
              {
                _args = [
                  "XF86AudioPrev"
                  (mkLuaInline ''hl.dsp.exec_cmd("playerctl previous")'')
                  { locked = true; }
                ];
              }
            ];
          };
        };
      };
    };
}
