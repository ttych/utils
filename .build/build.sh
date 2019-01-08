#!/bin/sh

SCRIPT_NAME="${0##*/}"
SCRIPT_PATH="${0%$SCRIPT_NAME}"
SCRIPT_PATH="${SCRIPT_PATH%/}"
SCRIPT_PATH=`cd "${SCRIPT_PATH:-$PWD}" && pwd -P`

SRC=src
TGT=bin
while getopts :s:t:h opt; do
    case $opt in
        s) SRC="$OPTARG" ;;
        t) TGT="$OPTARG" ;;
        h) usage ; exit 0 ;;
        *) usage ; exit 1 ;;
    esac
done

mkdir -p "$SCRIPT_PATH/../$TGT" || exit 1

build()
{
    build__src="$1"
    build__dir="$2"

    [ -z "$build__src" ] && return 1
    [ -z "$build__dir" ] && return 2

    build__tgt="$build__dir/${build__src##*/}"
    [ "$build__src" = "$build__tgt" ] && return 3

    sed -e "s;^\#%require%  *;. $build__dir/;g" \
        -e "s;^\#%toolsh_dir%;TOOLSH_DIR=\"$build__dir\";g" \
        -e "s;^\#%toolsh_file%;TOOLSH_FILE=\"$build__tgt\";g" \
        "$build__src" > "$build__tgt"

    build__right=755
    case "$build__tgt" in
        *.lib) build__right=644 ;;
    esac
    chmod $build__right "$build__tgt"
}

for file in "$SCRIPT_PATH/../$SRC/"*; do
    to="$SCRIPT_PATH/../$TGT/"
    build "$file" "$to" ||
        echo >&2 "failed to build $file to $to"
done
