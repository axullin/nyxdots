{
  flake.modules.nixos.desktop =
    {
      config,
      lib,
      pkgs,
      inputs,
      userName,
      ...
    }:
    let
      cfg = config.nyx.desktop.davinci-resolve;
      resolve = if cfg.studio then pkgs.davinci-resolve-studio else pkgs.davinci-resolve;

      # A second nixpkgs, used only by this wrapper. Ollama keeps the system
      # ROCm 7.2.3. That OpenCL stack's first context wedges this GPU.
      rocmPkgs = import inputs.nixpkgs-rocm711 {
        system = pkgs.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
      rocm = rocmPkgs.rocmPackages;

      # Resolve's own FHS sandbox bind-mounts /nix, so this ICD is visible
      # inside it. OCL_ICD_VENDORS replaces the default vendor search, which
      # keeps Mesa Rusticl and the system ROCm out of the process.
      # ocl-icd joins that directory to the filename with no extra slash.
      # 12.0.0 is the card's own ISA (gfx1200). 7.1.1 does not advertise
      # Navi 44 unless the runtime is told that name.
      wrapped = pkgs.symlinkJoin {
        name = "${resolve.pname}-rocm711";
        paths = [ resolve ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          for program in "$out/bin/"*; do
            target="$(readlink -f "$program")"
            rm "$program"
            makeWrapper "$target" "$program" \
              --set QT_QPA_PLATFORM xcb \
              --unset WAYLAND_DISPLAY \
              --set HSA_OVERRIDE_GFX_VERSION 12.0.0 \
              --set OCL_ICD_VENDORS ${rocm.clr.icd}/etc/OpenCL/vendors/ \
              --unset OCL_ICD_FILENAMES \
              --prefix LD_LIBRARY_PATH : ${
                lib.makeLibraryPath [
                  rocm.clr
                  rocm.rocm-runtime
                  rocm.rocm-comgr
                ]
              }
          done
        '';
      };
    in
    {
      options.nyx.desktop.davinci-resolve = {
        enable = lib.mkEnableOption ''
          DaVinci Resolve against a pinned ROCm 7.1.1 OpenCL runtime.
          Test stack for the RX 9060 XT. The free Linux build cannot decode
          H.264, H.265, or AAC
        '';

        studio = lib.mkEnableOption "the Studio edition";
      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages = [ wrapped ];

        # Color panels, Speed Editor, Editor Keyboard, and the Studio USB dongle.
        services.udev.packages = [ resolve ];

        hardware.graphics.enable = lib.mkDefault true;

        # /dev/kfd and the render node. The session user needs these for the
        # GPU, and logind's uaccess tag does not cover /dev/kfd.
        users.users.${userName}.extraGroups = [ "render" ];

        # Fairlight sets realtime priority and locks memory on its own threads,
        # outside the PipeWire rtkit path. Big media pools also blow past the
        # default file-descriptor limit.
        security.pam.loginLimits = [
          {
            domain = "@users";
            type = "-";
            item = "rtprio";
            value = "99";
          }
          {
            domain = "@users";
            type = "-";
            item = "memlock";
            value = "unlimited";
          }
          {
            domain = "@users";
            type = "soft";
            item = "nofile";
            value = "524288";
          }
          {
            domain = "@users";
            type = "hard";
            item = "nofile";
            value = "524288";
          }
        ];

        # Prefs, project library, cache, logs, and the Studio license.
        nyx.boot.impermanence.home.directories = [
          ".local/share/DaVinciResolve"
        ];
      };
    };
}
