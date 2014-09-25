#! /bin/bash
#
# Run integrartion test suite.
#
set -e


fail() { # fail with error message on stderr and exit code 1
    echo >&2 "ERROR:" "$@"
    exit 1
}

ensure_tool() {
    local tool="${1:?You must provide a tool name}"
    command which "$tool" >/dev/null 2>&1 || fail "'$tool' not found, please install it"
}


rootdir=$(cd $(dirname "$0") && pwd)
workdir="$rootdir/build"
mkdir -p "$workdir"
cd "$workdir"

# Fail fast for some obvious errors
ensure_tool "dh_virtualenv"
ensure_tool "cookiecutter"

# Create sample project (unattended)
prjname="cookiecutter-pypackage-minimal"
rm -rf "$workdir/"*cookiecutter* 2>/dev/null || :
test ! -d "$prjname" || rm -rf "$prjname"
yes | cookiecutter --no-input "https://github.com/borntyping/$prjname.git"
echo

# Now add "debian" directory
cp -rpl "$rootdir/"*cookiecutter.* "$workdir"
sed -r -i -e "s/pyvenv-foobar/$prjname/" "$workdir/cookiecutter.json"
cd "$prjname"
cookiecutter --no-input "$workdir/"
dch -r ""

# Build the package
dpkg-buildpackage -uc -us -b

# end of integration test
