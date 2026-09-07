{
  description = "System dependencies for developing wgpu-ocaml (AI-authored)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: builtins.listToAttrs (map (system: {
        name = system;
        value = f system;
      }) systems);
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          inherit (pkgs) lib;
          linux = pkgs.stdenv.hostPlatform.isLinux;

          # Keep OCaml/dune/ctypes in opam: nixpkgs need not carry OCaml 5.5.1.
          # Do not use nixpkgs.wgpu-native, whose ABI may differ from our pin.
          mkDevShell = software: pkgs.mkShell {
            packages = with pkgs; [ opam pkgconf pkg-config gnumake git curl unzip ]
              ++ lib.optionals linux [ bubblewrap vulkan-tools ];
            buildInputs = [ pkgs.libffi ];

            shellHook = lib.optionalString linux ''
              # dlopen must find the Vulkan loader and the binary's libgcc.
              # NixOS hardware drivers are exposed at /run/opengl-driver/lib.
              export LD_LIBRARY_PATH="${lib.makeLibraryPath [ pkgs.libffi pkgs.vulkan-loader pkgs.stdenv.cc.cc.lib ]}:/run/opengl-driver/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
            '' + lib.optionalString software ''
              # Discover the name rather than assume an architecture suffix.
              wgpu_lvp_icd=$(find ${pkgs.mesa}/share/vulkan/icd.d -name 'lvp_icd*.json' -print -quit)
              if [ -z "$wgpu_lvp_icd" ]; then
                echo "wgpu-ocaml: Mesa's lavapipe ICD was not found" >&2
                return 1
              fi
              export VK_DRIVER_FILES="$wgpu_lvp_icd"
              export VK_ICD_FILENAMES="$wgpu_lvp_icd"
              unset wgpu_lvp_icd
            '';
          };
        in
        { default = mkDevShell false; }
        // lib.optionalAttrs linux { software = mkDevShell true; });
    };
}
