{ config, ... }:
{
  flake.modules.homeManager.proxnix = {
    imports = with config.flake.modules.homeManager; [
      terminal
    ];

    nyx = {
      terminal = {
        fastfetch.enable = true;
        starship.enable = false;
      };
    };

    home.stateVersion = "26.05";
  };
}
