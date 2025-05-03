# Org-Roam Notes Website
[![built with garnix](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Fgarnix.io%2Fapi%2Fbadges%2Fcollinarnett%2Fcollinarnett.github.io%3Fbranch%3Dmain)](https://garnix.io/repo/collinarnett/collinarnett.github.io)

My website built from my org-roam notes.

## Project Overview

This repository contains:

1. A collection of Org-Roam notes on topics like programming, Haskell, and functional data structures
2. A Nix-based build system to convert these notes into a static website
3. GitHub Actions workflow for CI/CD to deploy the site to GitHub Pages

## Features

- **Org-Roam Integration**: Automatically handles backlinks and cross-references between notes
- **Nix Flake Support**: Uses Nix flakes for reproducible builds and development environment
- **Emacs Automation**: Uses Emacs in batch mode for publishing
- **Haskell Support**: Includes environment for Haskell development and note execution
- **GitHub Pages Deployment**: Automatically deploys the site using GitHub Actions

## Requirements

- [Nix](https://nixos.org/) with flakes enabled
- [direnv](https://direnv.net/) (optional but recommended)

## Notes Structure

The repository contains Org-Roam notes on various topics:

- **Programming**: General programming concepts
- **Haskell**: Notes on Haskell programming language
- **Functional Data Structures**: Study notes on the book "Purely Functional Data Structures"
- **Singletons**: Detailed notes on Haskell singletons

## Getting Started

### Development Environment

```bash
# Clone the repository
git clone https://github.com/collinarnett/collinarnett.github.io.git
cd org-roam-site

# If you have direnv
direnv allow

# Otherwise, enter the development shell manually
nix develop
```

### Building the Site

```bash
# Build the site
nix build

# The result is in ./result
```

### Local Preview

After building, you can view the site locally by opening `result/index.html` in your browser.

## Project Structure

- `*.org` - Org-Roam note files
- `flake.nix` - Nix flake configuration
- `publish.el` - Emacs Lisp script that handles publishing
- `nix/publish.nix` - Nix derivation for publishing
- `.github/workflows/ci.yaml` - GitHub Actions workflow
- `simple_inline.theme` - CSS theme for the published site

## How It Works

1. The Nix build system creates a controlled environment with Emacs and necessary packages
2. Emacs runs in batch mode executing `publish.el` to convert Org files to HTML
3. The resulting site is packaged and made available as the build output
4. GitHub Actions deploys this output to GitHub Pages

## Contributing

Feel free to open issues or submit pull requests with improvements or additions to the notes.
