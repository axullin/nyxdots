{ config, ... }:
{
  flake.modules.homeManager.proxnix =
    { pkgs, ... }:
    {
      imports = with config.flake.modules.homeManager; [
        terminal
      ];

      nyx = {
        terminal = {
          fastfetch.enable = true;
          starship.enable = true;
        };
      };

      home.packages = with pkgs; [
        claude-code
      ];

      home.stateVersion = "26.05";
    };
}
