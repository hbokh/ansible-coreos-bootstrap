#/bin/bash

set -e

INSTALL=/opt

cd $INSTALL

if [[ -e $HOME/.bootstrapped ]]; then
  exit 0
fi

PYPY_VERSION=2.4.0

wget -O - https://bitbucket.org/pypy/pypy/downloads/pypy-$PYPY_VERSION-linux64.tar.bz2 |tar -xjf -
mv -n pypy-$PYPY_VERSION-linux64 pypy

## library fixup
mkdir -p $INSTALL/pypy/lib
ln -snf /lib64/libncurses.so.5.9 $INSTALL/pypy/lib/libtinfo.so.5

mkdir -p $INSTALL/bin

cat > $INSTALL/bin/python <<EOF
#!/bin/bash
LD_LIBRARY_PATH=$INSTALL/pypy/lib:$LD_LIBRARY_PATH exec $INSTALL/pypy/bin/pypy "\$@"
EOF

chmod +x $INSTALL/bin/python
$INSTALL/bin/python --version

touch $HOME/.bootstrapped
