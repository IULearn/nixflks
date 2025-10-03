# nixflks

[![Nix Flakes: Test](../../actions/workflows/nix-flakes-test.yml/badge.svg)](../../actions/workflows/nix-flakes-test.yml)

Nix Flakes Collection.

## 📜 Overview

### Available Packages

The following packages are available for use.

<table>
  <thead>
    <tr>
      <th>Package</th>
      <th>Description</th>
      <th>Directory</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <strong><code>git-amend-commit-date</code></strong>
      </td>
      <td>Git extension to amend the author and committer date of the latest Git commit.</td>
      <td><code>pkgs/git-amend-commit-date</code></td>
    </tr>
    <tr>
      <td>
        <strong><code>git-rebase-commit-date</code></strong>
      </td>
      <td>Git extension to amend the author and committer date of each Git commit.</td>
      <td><code>pkgs/git-rebase-commit-date</code></td>
    </tr>
  </tbody>
</table>

## 🚀 Usage

### Command

<table>
  <thead>
    <tr>
      <th>Package</th>
      <th>Command</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <strong><code>git-amend-commit-date</code></strong>
      </td>
      <td><code>nix run github:IULearn/nixflks#git-amend-commit-date -- --version</code></td>
    </tr>
    <tr>
      <td>
        <strong><code>git-rebase-commit-date</code></strong>
      </td>
      <td><code>nix run github:IULearn/nixflks#git-rebase-commit-date -- --version</code></td>
    </tr>
  </tbody>
</table>

### Flake Input

To use the packages in your own `flake.nix`, add `nixflks` to your inputs.

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    nixflks = {
      url = "github:IULearn/nixflks";
      # Follow the nixpkgs of your project for consistency
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixflks, ... }@inputs: {
    # You can now reference packages like nixflks.packages.<system>.git-rebase-commit-date
  };
}
```

## 📖 Documentation

Below you will find a list of documentation for tools used in this project.

- **Nix**: Nix Package Manager - [Docs](https://nixos.org)
- **GitHub Actions**: Automation and Execution of Software Development Workflows - [Docs](https://docs.github.com/en/actions)

## 🐛 Found a Bug?

Thank you for your message! Please fill out a [bug report](../../issues/new?assignees=&labels=&template=bug_report.md&title=).

## 📖 License

This project is licensed under the [European Union Public License 1.2](https://interoperable-europe.ec.europa.eu/collection/eupl/eupl-text-eupl-12).