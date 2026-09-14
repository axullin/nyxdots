{
  flake.modules.homeManager.packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        catnip
        kotofetch
        terminal-rain-lightning
        tty-clock
      ];
    };
}
