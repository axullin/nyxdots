{
  flake.modules.nixos.core =
    {
      userName,
      ...
    }:
    {
      programs.nh = {
        enable = true;
        flake = "/home/${userName}/.config/nixos";
      };
    };
}
