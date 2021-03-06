#!/bin/bash

# ==> VARIABLES <==
# Software Versions
LIBTORRENT_VER="0.13.8"
RTORRENT_VER="0.9.8"
XMLRPC_VER="1.39.12"
PKG_RELEASE="1"
PREFIX="/usr"

# URLs
LIBTORRENT_URL="https://github.com/rakshasa/rtorrent-archive/raw/master/libtorrent-$LIBTORRENT_VER.tar.gz"
RTORRENT_URL="https://github.com/rakshasa/rtorrent-archive/raw/master/rtorrent-$RTORRENT_VER.tar.gz"
XMLRPC_URL="https://sourceforge.net/projects/xmlrpc-c/files/Xmlrpc-c%20Super%20Stable/$XMLRPC_VER/xmlrpc-c-$XMLRPC_VER.tgz/download"

# Misc.
SRC_DIR="$HOME/src"
DEB_DIR="$HOME/deb"

# ==> MAIN PROGRAM <==
set -e

# Remove old versions
#sudo dpkg -P xmlrpc-c
#sudo dpkg -P libtorrent
#sudo dpkg -P rtorrent
#sleep 3

# Install prerequisites.
sudo apt install -y checkinstall build-essential libtool libxml++2.6-dev libssl-dev libncurses5-dev libcurl4-openssl-dev

# Create src and build dirs.
if [ ! -d $SRC_DIR ]; then
	mkdir -p $SRC_DIR
fi

if [ ! -d $DEB_DIR ]; then
	mkdir -p $DEB_DIR
fi


# Build XMLRPC.
cd $SRC_DIR
if [ ! -f $SRC_DIR/xmlrpc-c-$XMLRPC_VER.tgz ]; then
	wget -O xmlrpc-c-$XMLRPC_VER.tgz $XMLRPC_URL
fi
if [ ! -d $SRC_DIR/xmlrpc-c-$XMLRPC_VER ]; then
	tar xvzf xmlrpc-c-$XMLRPC_VER.tgz
fi
cd $SRC_DIR/xmlrpc-c-$XMLRPC_VER
./configure --prefix="$PREFIX" --enable-libxml2-backend --disable-libwww-client --disable-wininet-client --disable-abyss-server --disable-cgi-server --disable-cplusplus
make -j8
sudo checkinstall -D --pkgrelease="$PKG_RELEASE" --install=no --fstrans=no -y
sleep 3
cp $SRC_DIR/xmlrpc-c-$XMLRPC_VER/xmlrpc-c_"$XMLRPC_VER"-"$PKG_RELEASE"_amd64.deb $DEB_DIR

#Install XMLRPC
sudo dpkg -i $DEB_DIR/xmlrpc-c_"$XMLRPC_VER"-"$PKG_RELEASE"_amd64.deb

sudo rm -rf $SRC_DIR/xmlrpc-c-$XMLRPC_VER


# Build Libtorrent.
cd $SRC_DIR
if [ ! -f $SRC_DIR/libtorrent-$LIBTORRENT_VER.tar.gz ]; then
	wget $LIBTORRENT_URL
fi
if [ ! -d $SRC_DIR/libtorrent-$LIBTORRENT_VER ]; then
	tar xvzf libtorrent-$LIBTORRENT_VER.tar.gz
fi
cd $SRC_DIR/libtorrent-$LIBTORRENT_VER
./autogen.sh
./configure --prefix="$PREFIX" --disable-debug --with-posix-fallocate
make -j8
sudo checkinstall -D --pkgrelease="$PKG_RELEASE" --install=no --fstrans=no -y
sleep 3
cp $SRC_DIR/libtorrent-$LIBTORRENT_VER/libtorrent_"$LIBTORRENT_VER"-"$PKG_RELEASE"_amd64.deb $DEB_DIR
sudo rm -rf $SRC_DIR/libtorrent-$LIBTORRENT_VER

#Install Libtorrent.
sudo dpkg -i $DEB_DIR/libtorrent_"$LIBTORRENT_VER"-"$PKG_RELEASE"_amd64.deb

# Build rTorrent.
cd $SRC_DIR
if [ ! -f $SRC_DIR/rtorrent-$RTORRENT_VER.tar.gz ]; then
	wget $RTORRENT_URL
fi
if [ ! -d $SRC_DIR/rtorrent-$RTORRENT_VER ]; then
	tar xvzf rtorrent-$RTORRENT_VER.tar.gz
fi
cd $SRC_DIR/rtorrent-$RTORRENT_VER
./autogen.sh
./configure --prefix="$PREFIX" --with-xmlrpc-c
make -j8
sudo checkinstall -D --pkgrelease="$PKG_RELEASE" --install=no --fstrans=no -y
sleep 3
cp $SRC_DIR/rtorrent-$RTORRENT_VER/rtorrent_"$RTORRENT_VER"-"$PKG_RELEASE"_amd64.deb $DEB_DIR
sudo rm -rf $SRC_DIR/rtorrent-$RTORRENT_VER
sudo ldconfig
