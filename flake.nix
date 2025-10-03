{
  description = "Nix Flakes Collection.";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    git-amend-commit-date-flake = {
      url = "./pkgs/git-amend-commit-date";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-rebase-commit-date-flake = {
      url = "./pkgs/git-rebase-commit-date";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.git-amend-commit-date-flake.follows = "git-amend-commit-date-flake";
    };
  };

  outputs =
    {
      nixpkgs,
      git-amend-commit-date-flake,
      git-rebase-commit-date-flake,
      ...
    }:
    let
      supportedSystems = nixpkgs.lib.systems.flakeExposed;

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});

      installNixPackages = pkgs: [
        pkgs.nix
        pkgs.busybox
      ];

      installNixProfilePackages = pkgs: [
        pkgs.nixd # Nix Language Server
        pkgs.nixfmt-rfc-style # Nix Formatter
      ];

      installNixShellScripts = pkgs: [
        (pkgs.writeShellScriptBin "log" ''
          # If the third argument is explicitly 'break', print a leading newline.
          # The default is now 'nobreak'.
          if [ "''${3:-nobreak}" = "break" ]; then
            echo
          fi

          # Run the gum log command with the first two arguments.
          ${pkgs.gum}/bin/gum log --level "$1" "$2"

          # If the fourth argument is explicitly 'break', print a trailing newline.
          # The default is now 'nobreak'.
          if [ "''${4:-nobreak}" = "break" ]; then
            echo
          fi
        '')
      ];

      installNixFormatter = pkgs: pkgs.nixfmt-tree;
    in
    {
      # Run: $ nix fmt
      formatter = forAllSystems (system: (installNixFormatter pkgs.${system}));

      # Run: $ nix develop
      devShells = forAllSystems (system: {
        default = pkgs.${system}.mkShellNoCC {
          packages = (installNixPackages pkgs.${system}) ++ (installNixShellScripts pkgs.${system});
        };
      });

      packages = forAllSystems (system: {
        # Run: $ nix profile install
        default = pkgs.${system}.buildEnv {
          name = "profile";
          paths = (installNixPackages pkgs.${system}) ++ (installNixProfilePackages pkgs.${system});
        };

        # Packages [Flakes]
        git-amend-commit-date = git-amend-commit-date-flake.packages.${system}.git-amend-commit-date;
        git-rebase-commit-date = git-rebase-commit-date-flake.packages.${system}.git-rebase-commit-date;
      });
    };
}
