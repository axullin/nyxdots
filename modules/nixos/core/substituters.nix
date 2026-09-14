{
  flake.modules.nixos.core = {
    nix.settings = {
      extra-substituters = [
        # nix-community binary cache
        "https://nix-community.cachix.org"
        # Hyprland binary cache
        "https://hyprland.cachix.org"
        # Niri compositor binary cache
        "https://niri.cachix.org"
        # Lantian / xuyh0120 attic cache (CachyOS kernel builds)
        "https://attic.xuyh0120.win/lantian"
      ];
      extra-trusted-public-keys = [
        # nix-community binary cache
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # Hyprland binary cache
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        # Niri compositor binary cache
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        # Lantian / xuyh0120 attic cache (CachyOS kernel builds)
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      ];
    };
  };
}
