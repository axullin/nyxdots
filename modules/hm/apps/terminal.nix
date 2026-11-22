{
  flake.modules.homeManager.apps =
    { pkgs, ... }:
    {
      nyx.impermanence.directories = [ ".config/kotofetch" ];

      home.packages = with pkgs; [
        catnip
        kotofetch
        terminal-rain-lightning
        tty-clock
      ];
    };
}
