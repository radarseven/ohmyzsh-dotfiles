#!/usr/bin/env zsh
# Layered brew bundle: shared Brewfile, then Brewfile.<tag> for each tag in
# this machine's profile (~/.config/dotfiles/profile).
#
#   ./bundle.sh            # install
#   ./bundle.sh check      # any brew bundle subcommand works
#   ./bundle.sh cleanup    # note: judges each layer alone — don't pass --force
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$DOTFILES_DIR/lib/profile.zsh"
profile_load

echo "🍺 Bundling for profile: ${TAGS[*]}"

for layer in "" "${TAGS[@]}"; do
    f="$DOTFILES_DIR/Brewfile${layer:+.$layer}"
    [[ -f "$f" ]] || continue
    echo ""
    echo "  → ${f:t}"
    # Keep going on failure so every layer gets reported, then fail at the end
    brew bundle "${@:-install}" --file="$f" || failed=1
done

exit ${failed:-0}
