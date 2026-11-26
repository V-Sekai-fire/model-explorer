{
  description = "The Model Explorer desktop packages, built offline from this repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # The guest programs come from their repositories' flakes (RFD66606-2501).
    headfit = {
      url = "github:V-Sekai-fire/interactor-headfit-guest/dev/flake-binaries";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    skintokens = {
      url = "github:V-Sekai-fire/interactor-skintokens-guest/dev/flake-binaries";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    motion = {
      url = "github:V-Sekai-fire/interactor-motion-guest/dev/flake-binaries";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    persona = {
      url = "github:V-Sekai-fire/interactor-taskweft-persona/dev/flake-binaries";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # interactor-usd-guest has no flake yet: its release.
    usd-elf = {
      url = "file+https://github.com/V-Sekai-fire/interactor-usd-guest/releases/download/v20261117-double.1/usd.elf";
      flake = false;
    };
    # The double-precision engine and the FoundationDB tools, one input a file, so flake.lock
    # holds the hash release.yml checks with SHA256SUMS. Then the auto-rig weights at one revision.
    engine-godot-linuxbsd-editor-double-x86-64 = {
      url = "file+https://github.com/V-Sekai-fire/entities-zone/releases/download/v0.0.0-20261112160857-1ae0c072e9aa/godot.linuxbsd.editor.double.x86_64";
      flake = false;
    };
    engine-godot-linuxbsd-template-release-double-x86-64 = {
      url = "file+https://github.com/V-Sekai-fire/entities-zone/releases/download/v0.0.0-20261112160857-1ae0c072e9aa/godot.linuxbsd.template_release.double.x86_64";
      flake = false;
    };
    engine-godot-windows-template-release-double-x86-64-llvm-exe = {
      url = "file+https://github.com/V-Sekai-fire/entities-zone/releases/download/v0.0.0-20261112160857-1ae0c072e9aa/godot.windows.template_release.double.x86_64.llvm.exe";
      flake = false;
    };
    engine-godot-macos-template-release-double-arm64 = {
      url = "file+https://github.com/V-Sekai-fire/entities-zone/releases/download/v0.0.0-20261112160857-1ae0c072e9aa/godot.macos.template_release.double.arm64";
      flake = false;
    };
    engine-libfdb-c-so = {
      url = "file+https://github.com/V-Sekai-fire/entities-zone/releases/download/v0.0.0-20261112160857-1ae0c072e9aa/libfdb_c.so";
      flake = false;
    };
    engine-libfdb-c-dylib = {
      url = "file+https://github.com/V-Sekai-fire/entities-zone/releases/download/v0.0.0-20261112160857-1ae0c072e9aa/libfdb_c.dylib";
      flake = false;
    };
    engine-fdb-c-dll = {
      url = "file+https://github.com/V-Sekai-fire/entities-zone/releases/download/v0.0.0-20261112160857-1ae0c072e9aa/fdb_c.dll";
      flake = false;
    };
    engine-fdbserver-linux-x86-64 = {
      url = "file+https://github.com/V-Sekai-fire/entities-zone/releases/download/v0.0.0-20261112160857-1ae0c072e9aa/fdbserver.linux.x86_64";
      flake = false;
    };
    engine-fdbserver-macos-arm64 = {
      url = "file+https://github.com/V-Sekai-fire/entities-zone/releases/download/v0.0.0-20261112160857-1ae0c072e9aa/fdbserver.macos.arm64";
      flake = false;
    };
    engine-fdbserver-windows-x86-64-exe = {
      url = "file+https://github.com/V-Sekai-fire/entities-zone/releases/download/v0.0.0-20261112160857-1ae0c072e9aa/fdbserver.windows.x86_64.exe";
      flake = false;
    };
    fdb-fdbcli-linux-x86-64 = {
      url = "file+https://github.com/V-Sekai-fire/datasource-foundationdb/releases/download/7.3.79-weftspun-dev.2/fdbcli.linux.x86_64";
      flake = false;
    };
    fdb-fdbcli-macos-arm64 = {
      url = "file+https://github.com/V-Sekai-fire/datasource-foundationdb/releases/download/7.3.79-weftspun-dev.2/fdbcli.macos.arm64";
      flake = false;
    };
    fdb-fdbcli-windows-x86-64-exe = {
      url = "file+https://github.com/V-Sekai-fire/datasource-foundationdb/releases/download/7.3.79-weftspun-dev.2/fdbcli.windows.x86_64.exe";
      flake = false;
    };
    weights-mesh-encoder-gguf = {
      url = "file+https://huggingface.co/chibifire/SkinTokens-GGUF-BF16/resolve/912d4d15c771a7d99d143802d0a103d8a45fa0c6/mesh-encoder.gguf";
      flake = false;
    };
    weights-skin-vae-gguf = {
      url = "file+https://huggingface.co/chibifire/SkinTokens-GGUF-BF16/resolve/912d4d15c771a7d99d143802d0a103d8a45fa0c6/skin-vae.gguf";
      flake = false;
    };
    weights-tokenrig-gguf = {
      url = "file+https://huggingface.co/chibifire/SkinTokens-GGUF-BF16/resolve/912d4d15c771a7d99d143802d0a103d8a45fa0c6/tokenrig.gguf";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      # The commit's Go pseudo-version (RFD66606-2312), as release.yml computes it.
      tag =
        if self ? rev then
          "v0.0.0-${self.lastModifiedDate}-${builtins.substring 0 12 self.rev}"
        else
          "v0.0.0-dirty";

      # The Linux editor only runs the import and the export, inside the build.
      editor = { stdenv, autoPatchelfHook, fontconfig, libx11, libxcursor, libxext
        , libxi, libxinerama, libxrandr, libxrender, libGL, alsa-lib, libpulseaudio
        , dbus, udev, libxkbcommon, wayland, zlib }:
        stdenv.mkDerivation {
          pname = "model-explorer-editor";
          version = "20261112160857";
          dontUnpack = true;
          nativeBuildInputs = [ autoPatchelfHook ];
          buildInputs = [ stdenv.cc.cc.lib dbus udev zlib ];
          runtimeDependencies = [
            fontconfig libx11 libxcursor libxext libxi libxinerama libxrandr
            libxrender libGL alsa-lib libpulseaudio dbus udev libxkbcommon wayland
          ];
          installPhase = ''
            install -Dm755 ${inputs.engine-godot-linuxbsd-editor-double-x86-64} $out/bin/godot
            install -Dm755 ${inputs.engine-libfdb-c-so} $out/bin/libfdb_c.so
          '';
        };

      viewer = { lib, stdenvNoCC, elixir, git, zip, gnutar, model-explorer-editor
        , headfit-elf, skintokens-elf, motion-elf, persona-elf }:
        stdenvNoCC.mkDerivation {
          pname = "model-explorer";
          version = tag;
          src = lib.cleanSourceWith {
            src = self;
            filter = path: _:
              !(builtins.elem (baseNameOf path) [ "flake.nix" "flake.lock" ".github" ]);
          };
          nativeBuildInputs = [ elixir git zip gnutar ];
          dontConfigure = true;
          dontFixup = true;
          buildPhase = ''
            export HOME=$TMPDIR LANG=C.UTF-8
            export SOURCE_DATE_EPOCH=${toString self.lastModified}
            export BUILD_SHA=${self.shortRev or "dirty"}
            # Copies, not links: the script hard-links the weights into each package.
            export ENGINE=$TMPDIR/engine W=$TMPDIR/w NOTICES=$TMPDIR/notices
            mkdir -p $ENGINE $W $NOTICES
            cp --no-preserve=mode ${inputs.engine-godot-linuxbsd-editor-double-x86-64} $ENGINE/godot.linuxbsd.editor.double.x86_64
            cp --no-preserve=mode ${inputs.engine-godot-linuxbsd-template-release-double-x86-64} $ENGINE/godot.linuxbsd.template_release.double.x86_64
            cp --no-preserve=mode ${inputs.engine-godot-windows-template-release-double-x86-64-llvm-exe} $ENGINE/godot.windows.template_release.double.x86_64.llvm.exe
            cp --no-preserve=mode ${inputs.engine-godot-macos-template-release-double-arm64} $ENGINE/godot.macos.template_release.double.arm64
            cp --no-preserve=mode ${inputs.engine-libfdb-c-so} $ENGINE/libfdb_c.so
            cp --no-preserve=mode ${inputs.engine-libfdb-c-dylib} $ENGINE/libfdb_c.dylib
            cp --no-preserve=mode ${inputs.engine-fdb-c-dll} $ENGINE/fdb_c.dll
            cp --no-preserve=mode ${inputs.engine-fdbserver-linux-x86-64} $ENGINE/fdbserver.linux.x86_64
            cp --no-preserve=mode ${inputs.engine-fdbserver-macos-arm64} $ENGINE/fdbserver.macos.arm64
            cp --no-preserve=mode ${inputs.engine-fdbserver-windows-x86-64-exe} $ENGINE/fdbserver.windows.x86_64.exe
            cp --no-preserve=mode ${inputs.fdb-fdbcli-linux-x86-64} $ENGINE/fdbcli.linux.x86_64
            cp --no-preserve=mode ${inputs.fdb-fdbcli-macos-arm64} $ENGINE/fdbcli.macos.arm64
            cp --no-preserve=mode ${inputs.fdb-fdbcli-windows-x86-64-exe} $ENGINE/fdbcli.windows.x86_64.exe
            cp --no-preserve=mode ${inputs.weights-mesh-encoder-gguf} $W/mesh-encoder.gguf
            cp --no-preserve=mode ${inputs.weights-skin-vae-gguf} $W/skin-vae.gguf
            cp --no-preserve=mode ${inputs.weights-tokenrig-gguf} $W/tokenrig.gguf
            chmod +x $ENGINE/godot.* $ENGINE/fdbserver.* $ENGINE/fdbcli.*
            cp LICENSE $ENGINE/LICENSE-model-explorer.txt

            # The macOS export template, as release.yml makes it: the exporter wants an app in a zip.
            t=$TMPDIR/macos_template.app/Contents
            mkdir -p $t/MacOS
            cp $ENGINE/godot.macos.template_release.double.arm64 $t/MacOS/godot_macos_release.arm64
            chmod +x $t/MacOS/godot_macos_release.arm64
            printf 'APPL????' > $t/PkgInfo
            cp tools/macos_template_Info.plist $t/Info.plist
            (cd $TMPDIR/macos_template.app && zip -qry $ENGINE/macos-template.zip .)

            cp LICENSE $NOTICES/LICENSE.md
            printf '%s\n' \
              "V-Sekai Model Explorer, skintokens viewer" \
              "Built from V-Sekai-fire/model-explorer@${self.rev or "dirty"} by its flake." \
              "Source and licences of the parts: https://github.com/V-Sekai-fire/model-explorer" \
              > $NOTICES/NOTICE
            printf '%s\n' \
              'cff-version: 1.2.0' \
              'message: "If you use this software, please cite it as below."' \
              'title: "V-Sekai Model Explorer"' \
              'authors:' \
              '  - name: "V-Sekai contributors"' \
              'repository-code: "https://github.com/V-Sekai-fire/model-explorer"' \
              'version: "${tag}"' \
              'commit: "${self.rev or "dirty"}"' \
              "date-released: \"$(date -u -d @$SOURCE_DATE_EPOCH +%Y-%m-%d)\"" \
              > $NOTICES/CITATION.cff

            # package_desktop.exs exports `git archive HEAD`; the flake source is no git checkout.
            git init -q
            git add -A
            GIT_AUTHOR_DATE=@$SOURCE_DATE_EPOCH GIT_COMMITTER_DATE=@$SOURCE_DATE_EPOCH \
              git -c user.name=flake -c user.email=flake@localhost commit -q -m source

            export GODOT=${model-explorer-editor}/bin/godot
            export ELF=${skintokens-elf}/skintokens.elf USD_ELF=${inputs.usd-elf}
            export MOTION_ELF=${motion-elf}/motion.elf HEADFIT_ELF=${headfit-elf}/headfit.elf
            export PERSONA_ELF=${persona-elf}/persona.elf
            elixir tools/package_desktop.exs pck $TMPDIR/out
            elixir tools/package_desktop.exs package $TMPDIR/out $W skintokens
          '';
          installPhase = ''
            mkdir -p $out
            cd $TMPDIR/out/skintokens
            mv skintokens-viewer-linux-x86_64.tar.gz $out/skintokens-viewer-${tag}-linux-x86_64.tar.gz
            mv skintokens-viewer-windows-x86_64.zip $out/skintokens-viewer-${tag}-windows-x86_64.zip
            mv skintokens-viewer-macos-arm64.zip $out/skintokens-viewer-${tag}-macos-arm64.zip
            cd $out
            sha256sum skintokens-viewer-* > SHA256SUMS
          '';
        };

      overlay = final: prev:
        (inputs.headfit.overlays.default final prev)
        // (inputs.skintokens.overlays.default final prev)
        // (inputs.motion.overlays.default final prev)
        // (inputs.persona.overlays.default final prev)
        // {
          model-explorer-editor = final.callPackage editor { };
          model-explorer = final.callPackage viewer { };
        };
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ overlay ];
      };
    in
    {
      overlays.default = overlay;
      packages.${system} = {
        viewer = pkgs.model-explorer;
        default = pkgs.model-explorer;
      };
    };
}
