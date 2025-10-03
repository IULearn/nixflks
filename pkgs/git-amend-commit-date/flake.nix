{
  description = "Git extension to amend the author and committer date of the latest Git commit.";

  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      supportedSystems = nixpkgs.lib.systems.flakeExposed;
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (system: {
        git-amend-commit-date = pkgs.${system}.writeShellScriptBin "git-amend-commit-date" ''
          #!${pkgs.${system}.bash}/bin/bash

          VERSION="1.0.0"

          if [ "$#" -eq 0 ]; then
            echo "Usage: git-amend-commit-date <date>" >&2
            echo "Try 'git-amend-commit-date --help' for more information." >&2
            exit 1
          fi

          case "$1" in
            --help)
              echo "git-amend-commit-date - Amend the author and committer date of the latest Git commit."
              echo
              echo "Usage:"
              echo "  git-amend-commit-date <date>"
              echo
              echo "Options:"
              echo "  --help       Show this help message and exit"
              echo "  --version    Show version information and exit"
              echo
              echo "Examples:"
              echo "  git-amend-commit-date \"1 days ago\""
              echo "  git-amend-commit-date \"2025-09-28T21:15:12+0000\""
              echo
              echo "Behavior:"
              echo "  This command sets both GIT_AUTHOR_DATE and GIT_COMMITTER_DATE to the given date"
              echo "  and amends the latest commit without changing its message."
              echo
              echo "Note:"
              echo "  This only affects the most recent commit. To rewrite multiple commits,"
              echo "  use 'git-rebase-commit-date' instead."
              exit 0
              ;;
            --version)
              echo "git-amend-commit-date version $VERSION"
              exit 0
              ;;
          esac

          DATE="$(date -d "$1" 2>/dev/null)"
          if [ -z "$DATE" ]; then
            echo "Error: Invalid date format." >&2
            exit 1
          fi

          GIT_COMMITTER_DATE="$DATE" \
          GIT_AUTHOR_DATE="$DATE" \
            ${pkgs.${system}.git}/bin/git commit \
              --amend \
              --no-edit \
              --date="$DATE"
        '';
      });
    };
}
