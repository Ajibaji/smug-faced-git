#!/usr/bin/env sh

# Borrowed from https://github.com/Sinjhin/SketchyMenu

# Font definitions
FONT="SF Pro"
NERD_FONT="JetBrainsMono Nerd Font Mono"

colours=(
    # colour Palette
    BLACK=0xff1a1a1a
    ASH=0xff3b3b3b
    GREY=0xff8f8f8f
    WHITE=0xffe6e6e6
    RED=0xffd1001f
    GREEN=0xff57c900
    LIME=0xffa3b500
    DARK_GREEN=0xff2c6600
    BLUE=0xff0043c9
    LIGHT_BLUE=0xff8aadf4
    YELLOW=0xffccb802
    LIGHT_YELLOW=0xffeed49f
    PURPLE=0xff7402cc
    ORANGE=0xffd44a00
    MAGENTA=0xffc6a0f6
    SKY=0xff91d7e3


    TRANSPARENT=0x00000000
    TEXT=0xffcee0d2

    SPOTIFY_GREEN=0xffa6da95
)

get_colour() {
    local COLOUR="$1"
    local OPACITY="${2:-}"   # optional, if omitted return full colour

    # find the colour value
    local val=""
    for entry in "${colours[@]}"; do
        IFS='=' read -r name value <<< "$entry"
        if [ "$name" = "$COLOUR" ]; then
            val="$value"
            break
        fi
    done

    if [ -z "$val" ]; then
        echo "colour $COLOUR not found" >&2
        return 1
    fi

    # If no opacity specified, return the full colour
    if [ -z "$OPACITY" ]; then
        echo "$val"
        return 0
    fi

    local hexdec=$(( (OPACITY * 255 + 50) / 100 ))
    # Format to two uppercase hex digits
    local hex="${hexdec#0x}"   # not strictly needed, just to be safe
    printf -v hex "%02X" "$hexdec"

    # Drop "0x" prefix, drop the first two hex digits (the AA), keep the rest
    # val is "0xAARRGGBB" so:
    local rgb="${val:4}"   # this removes "0xAA" → gives "RRGGBB"

    # Construct new colour
    echo "0x${hex}${rgb}"
}
