#!/bin/bash

pushd ~
mkdir -p ~/.irssi/scripts/autorun
pushd ~/.irssi/scripts

wget http://scripts.irssi.org/scripts/autorejoin.pl
chmod +x autorejoin.pl
pushd ~/.irssi/scripts/autorun
ln -snf ../autorejoin.pl .
popd

popd
popd

echo "Now run /script load autorejoin in your irssi session, and it will autorun when you next start."
