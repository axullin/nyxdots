{
  flake.modules.nixos.desktop =
    { inputs, ... }:
    {
      imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

      services.flatpak = {
        enable = true;
        packages = [
          "org.vinegarhq.Sober"
        ];
      };
    };
}
