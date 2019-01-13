#!/bin/sh
# -*- mode: sh -*-


RBENV_INSTALL_RUBY_VERSION="${RBENV_INSTALL_RUBY_VERSION:-2.4.3}"
RBENV_INSTALL_REPO_BASE="${RBENV_INSTALL_REPO_BASE:-https://github.com/rbenv}"
RBENV_INSTALL_REPO_NAME="${RBENV_INSTALL_REPO_NAME:-rbenv}"
RBENV_INSTALL_REPO_PLUGINS="${RBENV_INSTALL_REPO_PLUGIN_NAMES:-ruby-build rbenv-vars}"

RBENV_INSTALL_TMPDIR=
for tmp_dir in "$HOME/tmp" /local /var/tmp; do
    touch $tmp_dir/test.$$ \
        && rm -f $tmp_dir/test.$$ \
        && RBENV_INSTALL_TMPDIR="$tmp_dir" \
        && break
done

RBENV_INSTALL_PATH="${1}"
RBENV_INSTALL_PATH="${RBENV_INSTALL_PATH:-$(rbenv root 2>/dev/null)}"
RBENV_INSTALL_PATH="${RBENV_INSTALL_PATH:-$RBENV_ROOT}"
RBENV_INSTALL_PATH="${RBENV_INSTALL_PATH:-$HOME/.rbenv}"


clone_or_update()
{
    clone_or_update__source="$1"
    clone_or_update__target="$2"
    [ -z "$clone_or_update__source" ] && return 1
    [ -z "$clone_or_update__target" ] && return 1

    # clone
    cd "${clone_or_update__target}" 2>/dev/null || mkdir -p "${clone_or_update__target}" || return 1
    [ -d "$clone_or_update__target/.git" ] ||
        git clone -q "${clone_or_update__source}.git" "${clone_or_update__target}" ||
        return 1

    # update
    cd "${clone_or_update__target}" && git pull -q || \
            return 1
}

rbenv_profile()
{
    cat <<EOF
# rbenv profile
RBENV_ROOT="$RBENV_INSTALL_PATH" ; export RBENV_ROOT
PATH=\$RBENV_ROOT/bin:\$PATH ; export PATH
eval "\$(rbenv init -)"
EOF
}


set -e
# install rbenv
clone_or_update "$RBENV_INSTALL_REPO_BASE/$RBENV_INSTALL_REPO_NAME" \
                "$RBENV_INSTALL_PATH"

# install plugins
mkdir -p "$RBENV_INSTALL_PATH/plugins"
for plugin in $RBENV_INSTALL_REPO_PLUGINS; do
    clone_or_update "$RBENV_INSTALL_REPO_BASE/$plugin" \
                    "$RBENV_INSTALL_PATH/plugins/$plugin"
done

# profile
rbenv_profile
eval "$(rbenv_profile)"

# install ruby
[ -n "$RBENV_INSTALL_TMPDIR" ] && RBENV_BUILD_ROOT="$RBENV_INSTALL_TMPDIR"
rbenv install -s "$RBENV_INSTALL_RUBY_VERSION"
rbenv global "$RBENV_INSTALL_RUBY_VERSION"

# install bundler
gem install bundler
