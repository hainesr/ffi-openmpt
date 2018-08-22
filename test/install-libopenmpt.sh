#!/bin/sh
#
# Copyright (c) 2018 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.
#

set -ex

wget https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.3.11+release.autotools.tar.gz
tar xzf libopenmpt-0.3.11+release.autotools.tar.gz

cd libopenmpt-0.3.11+release.autotools && \
./configure --prefix=$TRAVIS_BUILD_DIR/usr \
            --disable-largefile \
            --disable-openmpt123 \
            --disable-examples \
            --disable-libopenmpt_modplug \
            --disable-libmodplug \
            --disable-doxygen-doc \
            --without-mpg123 \
            --without-ogg \
            --without-vorbis \
            --without-vorbisfile \
            --without-pulseaudio \
            --without-portaudio && \
make && \
make install
