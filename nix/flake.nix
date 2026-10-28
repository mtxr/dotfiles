{
  description = "Generic CLI tools for the dotfiles Nix profile";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      # One buildEnv per profile: whatever is listed here is on PATH,
      # whatever is removed is gone after the next `chezmoi apply`.
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.buildEnv {
            name = "dotfiles-profile";
            # CLIs the public dotfiles rely on (zsh, gitconfig, topgrade, scripts).
            paths = with pkgs; [
              antidote
              atuin
              bat
              btop
              delta
              diffnav
              direnv
              exiftool
              eza
              fd
              flow-control
              gh
              git
              git-lfs
              just
              mergiraf
              mise
              nmap
              pv
              ripgrep
              rust-parallel
              skim
              starship
              topgrade
              wireguard-tools
            ]
            # dircolors for dot_zshrc (uutils-prefixed, so macOS's own tools stay).
            ++ lib.optionals stdenv.isDarwin [ uutils-coreutils ];
          };
        }
      );
    };
}
