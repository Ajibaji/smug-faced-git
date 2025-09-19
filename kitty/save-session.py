#!/usr/bin/env python3
"""
this tool is used to convert Kitty session dump to Kitty session file which can be loaded by Kitty
"""

import json
import os
import sys


def cmdline_to_str(cmdline):
    """Convert a cmdline list to a space separated string."""
    s = ""
    for e in cmdline:
        s += f"{e} "

    return s.strip(" -")


def convert(session, exclude_env=False):
    """Convert a kitty session dict, into a kitty session file and output it."""
    first = True
    for os_window in session:
        if first:
            first = False
        else:
            print("\nnew_os_window\n")
        for tab in os_window["tabs"]:
            print("new_tab")
            print(f"layout {tab['layout']}")
            if tab["windows"]:
                for w in tab["windows"]:
                    print(f"cd {w['foreground_processes'][0]['cwd']}")
                    print(
                        f'launch --env "KITTY_WINDOW_ID={w["env"]["KITTY_WINDOW_ID"]}" {cmdline_to_str(w["cmdline"])}'
                    )
            print("\n")


if __name__ == "__main__":
    import argparse

    # Set up argument parser
    parser = argparse.ArgumentParser(
        description="this tool is used to convert Kitty session dump to Kitty session file which can be loaded by Kitty"
    )
    parser.add_argument(
        "--no-copy-env",
        action="store_true",
        help="Include environment variables in the output as well",
    )

    args = parser.parse_args()

    stdin = sys.stdin.readlines()
    session = json.loads("".join(stdin))
    convert(session, args.no_copy_env)
