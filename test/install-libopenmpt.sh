#!/bin/sh
#
# Copyright (c) 2018-2020, Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.
#

set -ex

VER=${TEST_LIBOPENMPT_VERSION:-0.3.11}
DIR=libopenmpt-${VER}+release.autotools
TAR=${DIR}.tar.gz

wget https://lib.openmpt.org/files/libopenmpt/src/${TAR}
tar xzf ${TAR}

cd ${DIR} && \
./configure --prefix=$TRAVIS_BUILD_DIR/usr \
            --disable-largefile \
            --disable-examples \
            --disable-libopenmpt_modplug \
            --disable-libmodplug \
            --disable-doxygen-doc \
            --without-mpg123 \
            --without-ogg \
            --without-vorbis \
            --without-vorbisfile \
            --without-pulseaudio \
            --without-portaudio \
            --without-sndfile \
            --without-flac && \
make && \
make install
