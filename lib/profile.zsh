# Machine profile helpers — sourced by bootstrap.sh and bundle.sh.
#
# A machine's role tags live in an untracked local file:
#   ~/.config/dotfiles/profile   →  e.g. "laptop personal"
# Tags compose: one form factor (laptop|desktop) + one ownership (personal|work).

DOTFILES_PROFILE="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/profile"

# Guess the form factor from hardware (not hostname — names collide and change)
profile_suggest_form() {
    if [[ "$(sysctl -n hw.model 2>/dev/null)" == *Book* ]]; then
        echo laptop
    else
        echo desktop
    fi
}

# Ask for the tags and write the profile. Suggestions are only ever seeds;
# ownership has no default, so a work machine can't become "personal" by
# someone leaning on the return key.
profile_prompt() {
    if [[ ! -t 0 ]]; then
        echo "✗ No profile at $DOTFILES_PROFILE and no terminal to ask on." >&2
        echo "  Create it by hand, e.g.: echo 'laptop personal' > $DOTFILES_PROFILE" >&2
        return 1
    fi

    local form owner suggested="$(profile_suggest_form)"

    echo ""
    echo "🖥  This machine has no profile yet."
    while [[ "$form" != (laptop|desktop) ]]; do
        read "form?  Form factor — laptop or desktop? [$suggested] "
        form="${form:-$suggested}"
    done
    while [[ "$owner" != (personal|work) ]]; do
        read "owner?  Ownership — personal or work? "
    done

    mkdir -p "$(dirname "$DOTFILES_PROFILE")"
    echo "$form $owner" > "$DOTFILES_PROFILE"
    echo "  ✓ Wrote '$form $owner' to $DOTFILES_PROFILE"
}

# Populate $TAGS from the profile, prompting first if it doesn't exist
profile_load() {
    [[ -f "$DOTFILES_PROFILE" ]] || profile_prompt || return 1
    TAGS=(${=$(<"$DOTFILES_PROFILE")})
}
