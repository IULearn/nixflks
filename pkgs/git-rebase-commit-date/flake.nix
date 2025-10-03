{
  description = "Git extension to amend the author and committer date of each Git commit.";

  inputs = {
    git-amend-commit-date-flake = {
      url = "../git-amend-commit-date";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      git-amend-commit-date-flake,
      ...
    }:
    let
      supportedSystems = nixpkgs.lib.systems.flakeExposed;
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (system: {
        git-rebase-commit-date = pkgs.${system}.writeShellScriptBin "git-rebase-commit-date" ''
          #!${pkgs.${system}.bash}/bin/bash

          VERSION="1.0.0"

          if [ "$#" -eq 0 ]; then
            echo "Usage: git-rebase-commit-date <rebase-args...>" >&2
            echo "Try 'git-rebase-commit-date --help' for more information." >&2
            exit 1
          fi

          case "$1" in
            --help)
              echo "git-rebase-commit-date - Amend the author and committer date of each commit."
              echo
              echo "Usage:"
              echo "  git-rebase-commit-date <rebase-args...>"
              echo
              echo "Options:"
              echo "  --help       Show this help message and exit"
              echo "  --version    Show version information and exit"
              echo
              echo "Examples:"
              echo "  git-rebase-commit-date --root HEAD"
              echo "  git-rebase-commit-date HEAD~2"
              echo
              echo "Behavior:"
              echo "  This command wraps 'git rebase --interactive' and injects a call to"
              echo "  'git amend-commit-date' for each commit in the rebase sequence."
              echo "  You will need to manually replace '<YOUR_DATE_HERE>' with a valid"
              echo "  date string like '4 days ago', '2025-09-28T21:15:12+0000', etc."
              echo
              echo "Note:"
              echo "  When using '--root', Git rebases from the initial commit."
              echo "  After rebasing, your HEAD may be detached. To reattach it:"
              echo
              echo "    DETACHED_HEAD=\"\$(git rev-parse HEAD)\"; \\"
              echo "        git checkout \"<some-branch-name>\" && \\"
              echo "        git reset --hard \"\$DETACHED_HEAD\""
              echo
              echo "  This ensures your branch reflects the rewritten history."
              exit 0
              ;;
            --version)
              echo "git-rebase-commit-date version $VERSION"
              exit 0
              ;;
          esac

          ${pkgs.${system}.git}/bin/git rebase \
            --interactive \
            --committer-date-is-author-date \
            --exec "${git-amend-commit-date-flake.packages.${system}.git-amend-commit-date}/bin/git-amend-commit-date 'YOUR_DATE_HERE'" \
            "$@"
        '';
      });
    };
}
