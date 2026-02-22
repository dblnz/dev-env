#!/usr/bin/env bash
# prepare-stow.sh — Back up or remove files that would conflict with GNU Stow
# Usage: prepare-stow.sh <dotfiles_dir> <target_dir> <pkg1> [pkg2 ...]
set -euo pipefail

DOTFILES_DIR="$1"
TARGET_DIR="$2"
shift 2
PACKAGES=("$@")

BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

for pkg in "${PACKAGES[@]}"; do
  pkg_dir="$DOTFILES_DIR/$pkg"
  [ -d "$pkg_dir" ] || continue

  # Find all files in the stow package
  find "$pkg_dir" -type f | while IFS= read -r src; do
    rel="${src#$pkg_dir/}"
    dest="$TARGET_DIR/$rel"

    # Skip if nothing exists at the destination
    [ -e "$dest" ] || [ -L "$dest" ] || continue

    # If it's already a stow symlink pointing to our dotfiles, skip it
    if [ -L "$dest" ]; then
      link_target=$(readlink "$dest")
      case "$link_target" in
        *dev/dotfiles/*) continue ;;
      esac
      # It's a symlink but not ours (e.g., Nix store) — remove it
      rm -f "$dest"
      echo "Removed symlink: $dest -> $link_target"
    else
      # It's a real file — back it up
      mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
      mv "$dest" "$BACKUP_DIR/$rel"
      echo "Backed up: $dest -> $BACKUP_DIR/$rel"
    fi
  done
done
