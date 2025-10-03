#!/usr/bin/env nix
#! nix develop ../../../. --ignore-env --keep-env-var TERM --keep-env-var HOME --command bash

# ─────────────────────────────────────────────────────────────
# Nix-Shebang Interpreter
# Docs:
# - https://nix.dev/manual/nix/2.29/command-ref/new-cli/nix.html#shebang-interpreter
# - https://nix.dev/manual/nix/2.29/command-ref/new-cli/nix3-env-shell.html#options-that-change-environment-variables

# ─────────────────────────────────────────────────────────────
# Utility Functions

nixflks_test__exit_code() {
    local flake="$1"

    # The rest of the arguments form the command to be executed.
    # The `shift` command removes the first argument ($1), so `$@` now
    # holds only the command and its parameters.
    shift

    # Capture all output and the exit code.
    output=$("$@" 2>&1)
    exit_code=$?

    if [ $exit_code -eq 0 ]; then
        log "info" "TEST [$flake]: PASS"
    else
        log "error" "TEST [$flake]: FAIL [Exit Code: $exit_code]" "break" "nobreak"
        
        log "debug" "TEST [$flake]: --- Captured Output Start ---"
        echo "$output"
        log "debug" "TEST [$flake]: --- Captured Output End ---" "nobreak" "break"

        exit 1
    fi
}

# ─────────────────────────────────────────────────────────────
# Test Functions

test__git_amend_commit_date() {
    nixflks_test__exit_code "pkgs/git-amend-commit-date" nix run .#git-amend-commit-date -- --version
}

test__git_rebase_commit_date() {
    nixflks_test__exit_code "pkgs/git-rebase-commit-date" nix run .#git-rebase-commit-date -- --version
}

# ─────────────────────────────────────────────────────────────
# Main Function

main() {
    test__git_amend_commit_date
    test__git_rebase_commit_date
}

main