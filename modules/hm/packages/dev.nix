{
  flake.modules.homeManager.packages =
    { pkgs, ... }:
    {
      nyx.impermanence.directories = [
        ".arduino15"
        ".config/arduino-ide"
        ".cursor"
        ".local/share/godot"
        ".config/godot"
      ];

      home.packages = with pkgs; [
        cursor-cli
        arduino-cli
        arduino-ide
        godot
      ];
    };
}
