{
  flake.modules.homeManager.terminal =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.nyx.terminal.starship;
    in
    {
      options.nyx.terminal.starship = {
        enable = lib.mkEnableOption "the Starship prompt";
      };

      config = lib.mkIf cfg.enable {
        programs.starship = {
          enable = true;
          enableFishIntegration = true;
          settings = {
            nix_shell.heuristic = true;
            format = "[](#769ff0)$directory[](fg:#769ff0 bg:#394260)$git_branch[](fg:#394260 bg:#212736)$nodejs$rust$golang$php[](fg:#212736 bg:#1d2230)$time[ ](fg:#1d2230)$character";

            # Overall settings
            directory = {
              style = "fg:#e3e5e5 bg:#769ff0";
              format = "[ $path ]($style)";
              truncation_length = 3;
              truncation_symbol = "󰖐/";
              substitutions = {
                "~" = "󰖐";
                "documents" = "󰈙 ";
                "downloads" = " ";
                "music" = " ";
                "pictures" = " ";
                "projects" = " ";
              };
            };

            # Look when in git repo
            git_branch = {
              symbol = "";
              style = "bg:#394260";
              format = "[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)";
            };
            git_status = {
              style = "bg:#394260";
              format = "[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)";
            };

            # Look when in nodejs
            nodejs = {
              symbol = "";
              style = "bg:#212736";
              format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
            };

            # Look while in rust
            rust = {
              symbol = "";
              style = "bg:#212736";
              format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
            };

            # Look while in golang
            golang = {
              symbol = "";
              style = "bg:#212736";
              format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
            };

            # Look while in php
            php = {
              symbol = "";
              style = "bg:#212736";
              format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
            };

            # Built in clock settings
            time = {
              disabled = false;
              time_format = "%R";
              style = "bg:#1d2230";
              format = "[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)";
            };

            # End of the prompt character config
            character = {
              success_symbol = "[󰁔](bold white)";
              error_symbol = "[×](bold red)";
            };
          };
        };
      };
    };
}
