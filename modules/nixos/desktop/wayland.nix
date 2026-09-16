{
  flake.modules.nixos.desktop = {
    # Wayland env independent of the GPU.
    # Electron stays on XWayland. Wayland + NVIDIA
    # breaks Arduino IDE
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "x11";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland";
    };
  };
}
