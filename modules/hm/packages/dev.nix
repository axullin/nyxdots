{
  flake.modules.homeManager.packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        stable.cursor-cli
        arduino-cli
        arduino-ide
        godot
      ];
    };
}
