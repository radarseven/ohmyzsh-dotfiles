#!/usr/bin/env zsh
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y-%m-%d-%H%M%S)"

echo "🚀 Rikerizing dotfiles from $DOTFILES_DIR"

# Ensure stow is installed
if ! command -v stow &> /dev/null; then
    echo "Installing stow via Homebrew..."
    brew install stow
fi

# Ensure ~/.config exists (for starship.toml)
mkdir -p "$HOME/.config"

# --- BACKUP EXISTING DOTFILES ---
# Snapshot every file that stow is about to touch.
# If anything goes wrong, restore from ~/.dotfiles-backup/<timestamp>/

FILES_TO_BACKUP=(
    .zshrc .mix-aliases .mix-exports .mix-path .mix-extra
    .hushlogin .screenrc
    .gitconfig .global-gitignore
    .vimrc .gvimrc
    .wgetrc
    .config/starship.toml
    .p10k.zsh
)

echo ""
echo "📦 Backing up existing dotfiles to $BACKUP_DIR"
mkdir -p "$BACKUP_DIR/.config"
mkdir -p "$BACKUP_DIR/.vim"

for file in "${FILES_TO_BACKUP[@]}"; do
    if [[ -e "$HOME/$file" || -L "$HOME/$file" ]]; then
        # Preserve directory structure in backup
        mkdir -p "$BACKUP_DIR/$(dirname "$file")"
        cp -RP "$HOME/$file" "$BACKUP_DIR/$file" 2>/dev/null && \
            echo "  ✓ ~/$file"
    fi
done

# Backup .vim directory if it exists and isn't already a symlink
if [[ -d "$HOME/.vim" && ! -L "$HOME/.vim" ]]; then
    cp -RP "$HOME/.vim" "$BACKUP_DIR/.vim" 2>/dev/null && \
        echo "  ✓ ~/.vim/"
fi

# Backup ~/bin scripts if they exist
if [[ -d "$HOME/bin" && ! -L "$HOME/bin" ]]; then
    cp -RP "$HOME/bin" "$BACKUP_DIR/bin" 2>/dev/null && \
        echo "  ✓ ~/bin/"
fi

echo "  Backup complete."

# --- FIGLET FONTS ---
echo ""
echo "🔤 Installing figlet fonts..."
if command -v figlet &> /dev/null; then
    FIGLET_FONTS_DIR=$(figlet -I 2 2>/dev/null || echo "/opt/homebrew/share/figlet/fonts")
    cp -v "$DOTFILES_DIR"/fonts/*.flf "$FIGLET_FONTS_DIR/" 2>/dev/null && echo "  ✓ figlet fonts installed" || echo "  ⚠ Could not install figlet fonts"
else
    echo "  ⚠ figlet not installed — skipping fonts (run: brew install figlet)"
fi

# --- STOW PACKAGES ---
echo ""
echo "🔗 Symlinking packages..."

PACKAGES=(shell git vim wget bin config)

for pkg in "${PACKAGES[@]}"; do
    echo "  Stowing $pkg..."
    # --adopt moves existing target files INTO the package dir,
    # then stow creates symlinks. Safe for migration from rsync copies.
    stow --adopt -v -d "$DOTFILES_DIR" -t "$HOME" "$pkg" 2>/dev/null || true
    # Re-stow to ensure symlinks are correct
    stow -R -v -d "$DOTFILES_DIR" -t "$HOME" "$pkg"
done

echo ""
echo "✅ All dotfiles symlinked!"
echo ""
echo "Your previous dotfiles are backed up at:"
echo "  $BACKUP_DIR"
echo ""
echo "To restore from backup:"
echo "  cd ~/.dotfiles && stow -D -t ~ shell git vim wget bin config"
echo "  cp -a $BACKUP_DIR/. ~/"
echo ""
echo "Next steps:"
echo "  brew bundle          # Install Homebrew packages"
echo "  source ~/.zshrc      # Reload shell config"
echo ""
echo "Make it so. 🖖"
