{ inputs, ... }:
{
  flake.overlays = {
    additions = final: _prev: import ../../pkgs { pkgs = final; };

    minecraft = inputs.nix-minecraft.overlay;

    modifications = _final: prev: {
      hyprland-git = inputs.hyprland.packages.${prev.stdenv.hostPlatform.system};
    };

    stable-packages = final: _prev: {
      stable = import inputs.nixpkgs-stable {
        system = final.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    };
  };

  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = builtins.attrValues inputs.self.overlays;
      };
    };
}
