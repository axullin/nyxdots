{
  flake.modules.nixos.core =
    {
      userName,
      ...
    }:
    {
      nyx.impermanence.home.directories = [ ".config/nixos" ];

      programs.nh = {
        enable = true;
        flake = "/home/${userName}/.config/nixos";
      };
    };
}
