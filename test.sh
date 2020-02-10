#! /bin/bash
#
# Run integration test suite.
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
python3 -c "assert (1, 1) <= tuple(int(i) for i in '$(dh_virtualenv --version | cut -f2 -d' ')'.split('.')), 'You need dh_virtualenv 1.1+'"
test -f "$rootdir/README.md" || fail 'Use a full git clone!'

# Create sample project (unattended)
prjname="dhvtst"
rm -rf "$workdir/"*cookiecutter* 2>/dev/null || :
test ! -d "$prjname" || rm -rf "$prjname"
git clone "https://github.com/borntyping/cookiecutter-pypackage-minimal.git"
sed -r -i -e "s/cookiecutter.pypackage.minimal/$prjname/" "$workdir/cookiecutter-pypackage-minimal/cookiecutter.json"
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
cd ..

# Check the package
deb=$(ls -1 $prjname*.deb)
while read i; do
    dpkg-deb -c $deb | egrep "$i" >/dev/null || fail "DPKG content misses '$i'"
done <<'EOF'
/opt/venvs/dhvtst/bin/python3
lib/python[.0-9]+/site-packages/dhvtst/__init__
EOF

while read i; do
    dpkg-deb -I $deb | egrep "$i" >/dev/null || fail "DPKG metadata misses '$i'"
done <<'EOF'
Package: dhvtst
Homepage: https://github.com/jschmoe/foobar
Description: A Python package
EOF


# Yay!
echo
echo "*** ALL OK ***"
# end of integration test
