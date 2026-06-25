#!/usr/bin/env zsh

set -euo pipefail

CONFIG_DIR="$HOME/.config/sketchybar"
PROFILE_FILE="$CONFIG_DIR/.display_profile"
AEROSPACE_CONFIG="$HOME/.config/aerospace/aerospace.toml"
WORK_RIGHT_GAP=80
DEFAULT_RIGHT_GAP=20
DEFAULT_VERTICAL_GAP=40

usage() {
    echo "Usage: $(basename "$0") <work|home|laptop|auto>"
    exit 1
}

if [[ $# -ne 1 ]]; then
    usage
fi

case "$1" in
    work|home|laptop)
        printf "%s\n" "$1" > "$PROFILE_FILE"
        ;;
    auto)
        rm -f "$PROFILE_FILE"
        ;;
    *)
        usage
        ;;
esac

# Keep extra right-side padding only for the vertical work bar.
if [[ -f "$AEROSPACE_CONFIG" ]]; then
    target_gap="$DEFAULT_RIGHT_GAP"
    if [[ "$1" == "work" ]]; then
        target_gap="$WORK_RIGHT_GAP"
        perl -i -pe 's/^outer\.right\s*=.*$/outer.right = [{ monitor.main = '"$WORK_RIGHT_GAP"' }, '"$DEFAULT_RIGHT_GAP"']/' "$AEROSPACE_CONFIG"
    else
        perl -i -pe 's/^outer\.right\s*=.*$/outer.right = '"$DEFAULT_RIGHT_GAP"'/' "$AEROSPACE_CONFIG"
    fi

    perl -i -pe 's/^outer\.top\s*=.*$/outer.top = '"$DEFAULT_VERTICAL_GAP"'/' "$AEROSPACE_CONFIG"
    perl -i -pe 's/^outer\.bottom\s*=.*$/outer.bottom = '"$DEFAULT_VERTICAL_GAP"'/' "$AEROSPACE_CONFIG"

    if ! aerospace reload-config >/dev/null 2>&1; then
        echo "Warning: couldn't reload AeroSpace. Start AeroSpace.app, then run: aerospace reload-config"
    fi
fi

sketchybar --reload
if [[ "$1" == "work" ]]; then
    echo "SketchyBar profile set to: $1 (AeroSpace outer.right=[{ monitor.main = $WORK_RIGHT_GAP }, $DEFAULT_RIGHT_GAP], outer.top/bottom=$DEFAULT_VERTICAL_GAP)"
else
    echo "SketchyBar profile set to: $1 (AeroSpace outer.right=$DEFAULT_RIGHT_GAP, outer.top/bottom=$DEFAULT_VERTICAL_GAP)"
fi
