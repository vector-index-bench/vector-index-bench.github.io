{
  description = "VIBE benchmark website (Quarto)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});

      # nixpkgs wires quarto to its own pandoc, but the two versions have to
      # match: Quarto 1.9 emits pandoc's `--syntax-highlighting` option, which
      # only exists from pandoc 3.8 on, so nixpkgs' pandoc 3.7 fails every
      # render with `Aeson exception: Unknown option "syntax-highlighting"`.
      #
      # To bump: run `quarto check`, which names the version it wants, then
      # update pandocVersion and refresh the hashes with
      #   nix-prefetch-url https://github.com/jgm/pandoc/releases/download/<ver>/<asset>
      pandocVersion = "3.8.3";
      pandocAssets = {
        x86_64-linux = {
          asset = "linux-amd64.tar.gz";
          hash = "sha256-wiT6uJ+CfTYjOA7LfBB4wWPHachJoUrCfo07+7kUybQ=";
        };
        aarch64-linux = {
          asset = "linux-arm64.tar.gz";
          hash = "sha256-FmpaNzh+sQvUxPJCqBCb7vdVrB6NTrA5xrXr0dkY2Nc=";
        };
        x86_64-darwin = {
          asset = "x86_64-macOS.zip";
          hash = "sha256-ki41wCENfKIO6TJ4ETYdbX8O8K3aCJ4OdMs3VsPXE/k=";
        };
        aarch64-darwin = {
          asset = "arm64-macOS.zip";
          hash = "sha256-Pq6zvRCYKuy6XddhWHRaT4Ba+zmrcqUZu6JTPJjOAC0=";
        };
      };

      # Upstream's release binaries, which ship the version Quarto expects.
      # The Linux ones are statically linked, so they need no patching.
      pandocFor = pkgs:
        let
          inherit (pandocAssets.${pkgs.stdenv.hostPlatform.system}) asset hash;
        in
        pkgs.stdenvNoCC.mkDerivation {
          pname = "pandoc-bin";
          version = pandocVersion;

          src = pkgs.fetchurl {
            url = "https://github.com/jgm/pandoc/releases/download/${pandocVersion}/pandoc-${pandocVersion}-${asset}";
            inherit hash;
          };

          nativeBuildInputs = pkgs.lib.optional (pkgs.lib.hasSuffix ".zip" asset) pkgs.unzip;

          dontConfigure = true;
          dontBuild = true;

          installPhase = ''
            runHook preInstall
            mkdir -p $out/bin $out/share
            cp bin/pandoc $out/bin/pandoc
            cp -r share/. $out/share/
            runHook postInstall
          '';

          # quarto's wrapper resolves pandoc with lib.getExe, which otherwise
          # derives the binary name from pname and looks for `pandoc-bin`.
          meta.mainProgram = "pandoc";
        };

      quartoFor = pkgs: pkgs.quarto.override { pandoc = pandocFor pkgs; };
    in
    {
      packages = forAllSystems (pkgs: rec {
        pandoc = pandocFor pkgs;
        quarto = quartoFor pkgs;
        default = quarto;
      });

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = [ (quartoFor pkgs) pkgs.gnumake ];
        };
      });
    };
}
