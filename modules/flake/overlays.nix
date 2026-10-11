{ inputs, ... }:
{
  flake.overlays = {
    additions = final: _prev: import ../../pkgs { pkgs = final; };

    minecraft = inputs.nix-minecraft.overlay;

    modifications = _final: prev: {
      hyprland-git = inputs.hyprland.packages.${prev.stdenv.hostPlatform.system};

      # VTK < 9.6 renames VTK::pegtl to VTK::vtkpegtl, but nixpkgs only disables
      # the external dependency under the old name. Configure then fails looking
      # for PEGTL. Hydra's vtk is broken the same way, so this cannot come from
      # cache. FreeCAD is taken from stable instead; see modeling/apps.nix.
      vtk = prev.vtk.overrideAttrs (old: {
        cmakeFlags = old.cmakeFlags ++ [
          (prev.lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_vtkpegtl" false)
        ];
      });
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
