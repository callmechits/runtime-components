#!/usr/bin/env bash
#
# install.sh: put the rc files in this repository to work.
#
# Usage:
#   ./install.sh             install everything
#   ./install.sh --dry-run   show what would happen, change nothing
#   ./install.sh --no-omz    skip installing oh-my-zsh
#
# What it does:
#   1. Copies each rc file here into your home directory, e.g.
#        ~/runtime_components/vimrc  ->  ~/.vimrc
#      These are copies: after editing a file in the repo, run this
#      script again to install the new version.
#   2. Copies gitconfig to ~/.gitconfig.rc and tells git to also read it
#      (your name and email stay in ~/.gitconfig, out of this repository).
#   3. Installs oh-my-zsh, if zsh is available.
#
# Safe to run more than once. Nothing is ever deleted: a file already in
# the way is renamed to  ~/.NAME.backup-DATE-TIME  first.

set -eu

# Files in this repository that become ~/.NAME. Missing ones are skipped,
# so add names here as your collection grows.
FILES=".bashrc .zshrc .vimrc .gdbinit"

OMZ_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

# ---------------------------------------------------------------------------
# Options
# ---------------------------------------------------------------------------
DRY_RUN=0
INSTALL_OMZ=1
for arg in "$@"; do
    case "$arg" in
        -n|--dry-run) DRY_RUN=1 ;;
        --no-omz)     INSTALL_OMZ=0 ;;
        -h|--help)    sed -n '3,20p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *)            echo "unknown option: $arg  (try --help)" >&2; exit 1 ;;
    esac
done

# Absolute path of the directory holding this script, so it works no matter
# which directory you run it from.
REPO_DIR="$(cd "$(dirname "$0")" && pwd -P)"
STAMP="$(date +%Y%m%d-%H%M%S)"

# Run a command, or just print it during a dry run.
run() {

