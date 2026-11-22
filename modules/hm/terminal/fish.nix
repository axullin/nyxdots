{
  flake.modules.homeManager.terminal = {
    nyx.impermanence.directories = [ ".local/share/fish" ];

    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set -g fish_greeting
        set -g fish_color_normal b2b2b2
        set -g fish_color_command 769ff0 --bold
        set -g fish_color_keyword d1d1d1
        set -g fish_color_quote 6a9955
        set -g fish_color_redirection d1d1d1
        set -g fish_color_end d1d1d1
        set -g fish_color_error 769ff0
        set -g fish_color_param cccccc
        set -g fish_color_comment 6c7086
        set -g fish_color_selection --background=394260
        set -g fish_color_search_match --background=394260
        set -g fish_color_operator d1d1d1
        set -g fish_color_escape d1d1d1
        set -g fish_color_autosuggestion 6c7086

        # Completion Pager Colors
        set -g fish_pager_color_progress 6c7086
        set -g fish_pager_color_prefix 769ff0
        set -g fish_pager_color_completion cccccc
        set -g fish_pager_color_description 6c7086
      '';
    };

    home.shellAliases = {
      vi = "nvim";
      cdc = "cd ~/.config/nixos/";
    };
  };
}
