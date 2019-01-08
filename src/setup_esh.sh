#!/bin/sh

SCRIPT_NAME="${0##*/}"
SCRIPT_PATH="${0%$SCRIPT_NAME}"
SCRIPT_PATH="${SCRIPT_PATH%/}"
SCRIPT_PATH=`cd "${SCRIPT_PATH:-$PWD}" && pwd -P`

INSTALL_PATH="${1:-$HOME/.esh}"
GIT_REPOS="https://github.com/ttych/esh.git
           https://gitlab.com/ttych/esh.git"


if [ -d "$INSTALL_PATH" ] && [ -d "$INSTALL_PATH/.git" ]; then
    cd "$INSTALL_PATH/" && git pull --no-rebase --ff-only
    [ -r install.sh ] && ./install.sh
else
    for git_repo in $GIT_REPOS; do
        if git clone "$git_repo" "$INSTALL_PATH"; then
            cd "$INSTALL_PATH" &&
                [ -r install.sh ] &&
                ./install.sh
            break
        fi
        rm -Rf "$INSTALL_PATH"
    done
fi
