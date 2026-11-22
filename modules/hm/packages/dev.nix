{
  flake.modules.homeManager.packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        cursor-cli
        arduino-cli
        arduino-ide
        godot
      ];
    };
}
