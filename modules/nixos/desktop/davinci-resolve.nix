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
      # 21.0.4 from a pinned nixpkgs, built with the main package set.
      resolve =
        pkgs.callPackage "${inputs.nixpkgs-resolve2104}/pkgs/by-name/da/davinci-resolve/package.nix"
          {
            studioVariant = cfg.studio;
          };

      # resolve-aacfix restores AAC decode. It knows 21.0.x only.
      aacfix = pkgs.fetchzip {
        url = "https://github.com/josephg/resolve-aacfix/releases/download/v0.1.1/resolve-aacfix-v0.1.1-linux-x86_64.tar.gz";
        hash = "sha256-bVf/dedOddWQGqRc7nT8SW+vUWpFw1de2NLh1AtB3RA=";
      };

      # Its bundled e9tool is a generic Linux binary. The release checksums
      # vendor/, so patched copies live here and AAC_E9TOOL points at them.
      e9tools = pkgs.stdenv.mkDerivation {
        name = "resolve-aacfix-e9tools";
        src = "${aacfix}/vendor/e9patch";
        nativeBuildInputs = [ pkgs.autoPatchelfHook ];
        buildInputs = [
          pkgs.zlib
          pkgs.stdenv.cc.cc.lib
        ];
        installPhase = ''
          install -Dm755 e9tool e9patch -t $out/bin
        '';
      };

      # A symlinked copy of the install that Resolve runs from when the AAC fix
      # or extraCommands change anything. Everything else stays a link, so this
      # adds little to the store.
      customized = cfg.aacFix || cfg.extraCommands != "";
      resolveCustom =
        pkgs.runCommand "${resolve.davinci.name}-custom"
          {
            nativeBuildInputs = with pkgs; [
              unzip
              squashfsTools
              python3
              binutils
              perl
            ];
          }
          (
            ''
              cp -rs --no-preserve=mode ${resolve.davinci} $out
              # cp -rs points every link at the stock tree, so libavcodec.so.60 would
              # still load the stock libavcodec.so.60.3.100. Keep the original targets.
              (cd ${resolve.davinci} && find . -type l) | while read -r link; do
                ln -sfn "$(readlink "${resolve.davinci}/$link")" "$out/$link"
              done
              # Studio bind-mounts the user's license and Extras over these stock dirs
              # at launch. Link to them so this tree sees the mounted ones.
              for dir in .license Extras; do
                rm -rf "$out/$dir"
                ln -s "${resolve.davinci}/$dir" "$out/$dir"
              done
              # Resolve finds its install through its own path. A real file here
              # makes it use this tree, not the stock one. The nixpkgs build adds a
              # driver runpath to bin/resolve, which shifts its bytes and reads as
              # already patched to aacfix. The stock binary comes from the installer
              # instead, so byte edits see the same file either way. 193760 is where
              # the squashfs starts in 21.0.4.
              unzip -p ${resolve.davinci.src} '*.run' > installer.run
              unsquashfs -no-progress -o 193760 -d stock installer.run bin/resolve
              rm installer.run
              rm $out/bin/resolve
              install -m755 stock/bin/resolve $out/bin/resolve
            ''
            + lib.optionalString cfg.aacFix ''
              AAC_E9TOOL=${e9tools}/bin/e9tool \
                bash ${aacfix}/aac-patch-tree apply --originals remove $out
            ''
            + ''
              cd $out
              stock=${resolve.davinci}
              ${cfg.extraCommands}
            ''
          );

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
            extraArgs=()
        ''
        # The FHS wrapper runs its arguments in place of the stock resolve.
        # Its LD_LIBRARY_PATH appends the stock libs, so the custom libs go first.
        + lib.optionalString customized ''
          if [ "$(basename "$program")" = ${lib.escapeShellArg (lib.getName resolve)} ]; then
            extraArgs=(
              --add-flags ${resolveCustom}/bin/resolve
              --prefix LD_LIBRARY_PATH : ${resolveCustom}/libs:/run/opengl-driver/lib
            )
          fi
        ''
        + ''
            rm "$program"
            makeWrapper "$target" "$program" "''${extraArgs[@]}" \
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

        aacFix = lib.mkEnableOption "AAC decode via resolve-aacfix (Studio 21.0.x only)";

        extraCommands = lib.mkOption {
          type = lib.types.lines;
          default = "";
          description = ''
            Shell run in a copy of the Resolve tree, after the AAC fix when that is
            on, with $out as the working directory and $stock as the unpatched
            tree. Most files there are symlinks into the read-only store, so
            replace one with rm before writing it. bin/resolve is a real file.
          '';
        };
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
        nyx.impermanence.home.directories = [
          ".local/share/DaVinciResolve"
        ];
      };
    };
}
