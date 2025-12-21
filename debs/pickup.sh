#! /bin/bash

HERE=$(pwd)

# BACKUP EXISTING POOL DIRECTORY
if [ -d pool ]; then
    mv pool pool.old 1>/dev/null 2>&1
fi

mkdir pool

# ANALYZE PACKAGE LIST
PKGS=$(cat ../more.list | awk '{print $1}')

for PKG in $PKGS; do
    DIR=$(echo $PKG | cut -c1)
    DIRL=$(echo $PKG | cut -c1-3)
    DIRLD=$(echo $PKG | cut -c1-4)
    DIRC=$(echo $PKG | cut -c1-5)

    if [ "x$DIRL" = "xlib" ]; then
        DIR=$DIRLD
    fi

    if [[ "x$DIRC" = "xlibc-" ]] || [[ "x$DIRC" = "xlibc6" ]]; then
        DIR="g"
    fi

    echo -n "PICKING UP $PKG to pool/main/$DIR/$PKG ... "
    if [ ! -d pool/main/$DIR/$PKG ]; then
        mkdir -p pool/main/$DIR/$PKG 1>/dev/null 2>&1
    fi
    cd pool/main/$DIR/$PKG
    apt download $PKG #1>/dev/null 2>&1
    apt source $PKG #1>/dev/null 2>&1
    rm -rf ${PKG}-*/ 1>/dev/null 2>&1
    cd $HERE
    echo DONE
done