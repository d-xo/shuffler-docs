{
  description = "shuffler-docs — static site build & dev shell";

  # Pinned to the revision the host's flake registry already resolves to, so the
  # dev shell reuses the existing store. Bump with `nix flake update`.
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/a3096196e347501a3c86a3fd86af02400c40520f";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = [
            pkgs.pandoc      # markdown -> html
            pkgs.gnumake     # build driver
            pkgs.entr        # rebuild on source change
            pkgs.live-server # serve + live browser reload
          ];
          shellHook = ''
            echo "shuffler-docs: 'make' builds, 'make serve' serves with live reload"
          '';
        };
      });
    };
}
