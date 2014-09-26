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

deactivate 2>/dev/null || :
rootdir=$(cd $(dirname "$0") && pwd)
workdir="/tmp/dhvtst-$USER"
##trap "rm -rf $workdir" ERR EXIT TERM
rm -rf "$workdir" 2>/dev/null || :
mkdir -p "$workdir"
cd "$workdir"

# Fail fast for some obvious errors
ensure_tool "dh_virtualenv"
ensure_tool "cookiecutter"
python -c "assert ('0','8') <= tuple('$(dh_virtualenv --version | cut -f2 -d' ')'.split('.')), 'You need dh_virtualenv 0.8+'"

# Create sample project (unattended)
prjname="dhvtst"
rm -rf "$workdir/"*cookiecutter* 2>/dev/null || :
test ! -d "$prjname" || rm -rf "$prjname"
git clone "https://github.com/borntyping/cookiecutter-pypackage-minimal.git"
sed -r -i -e "s/cookiecutter-pypackage-minimal/$prjname/" "$workdir/cookiecutter-pypackage-minimal/cookiecutter.json"
cookiecutter --no-input "cookiecutter-pypackage-minimal/"
echo

# Now add "debian" directory
cp -rp "$rootdir/"*cookiecutter.* "$workdir"
sed -r -i -e "s/pyvenv-foobar/$prjname/" "$workdir/cookiecutter.json"
cd "$prjname"
cookiecutter --no-input "$workdir/"
dch -r ""
echo "include README.rst" >MANIFEST.in # fix "cookiecutter-pypackage-minimal" bug

# Build the package
dpkg-buildpackage -uc -us -b

# end of integration test
