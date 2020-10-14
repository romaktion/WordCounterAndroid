#!/bin/bash

SOURCEDIR=libiconv-1.16
ARM32NAME=armeabi-v7a
ARM64NAME=arm64-v8a
I32NAME=x86
I64NAME=x86_64

export WORK_DIR=$PWD/libiconv
export API=26
export ANDROID_NDK_ROOT=$HOME/Android/android-ndk

echo Now we need to install build-essential if not installed before, please enter the sudo passwd!

sudo apt update
sudo apt-get -y install build-essential
sudo apt-get -y install curl

FILE=$SOURCEDIR.tar.gz
if [ ! -f "$FILE" ]; then
    curl https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.16.tar.gz --output $SOURCEDIR.tar.gz
fi

rm -rf $WORK_DIR/
rmdir $SOURCEDIR

#arm64-v8a*******************************************************************
tar xzf $SOURCEDIR.tar.gz
cd $SOURCEDIR

# Only choose one of these, depending on your build machine...
export TOOLCHAIN=$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64

# Only choose one of these, depending on your device...
export TARGET=aarch64-linux-android

# Configure and build.
export AR=$TOOLCHAIN/bin/$TARGET-ar
export AS=$TOOLCHAIN/bin/$TARGET-as
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
export LD=$TOOLCHAIN/bin/$TARGET-ld
export RANLIB=$TOOLCHAIN/bin/$TARGET-ranlib
export STRIP=$TOOLCHAIN/bin/$TARGET-strip
./configure --prefix=$WORK_DIR/$ARM64NAME --host $TARGET
make
make install

#delete intermediate folder
cd ..

rm -rf $SOURCEDIR/
rmdir $SOURCEDIR

#armeabi-v7a*******************************************************************
tar xzf $SOURCEDIR.tar.gz
cd $SOURCEDIR

# Only choose one of these, depending on your build machine...
export TOOLCHAIN=$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64

# Only choose one of these, depending on your device...
export TARGET=armv7a-linux-androideabi

# Configure and build.
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++

./configure --prefix=$WORK_DIR/$ARM32NAME --host $TARGET
make
make install

#delete intermediate folder
cd ..

rm -rf $SOURCEDIR/
rmdir $SOURCEDIR

#x86*******************************************************************
tar xzf $SOURCEDIR.tar.gz
cd $SOURCEDIR

# Only choose one of these, depending on your build machine...
export TOOLCHAIN=$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64

# Only choose one of these, depending on your device...
export TARGET=i686-linux-android

# Configure and build.
export AR=$TOOLCHAIN/bin/$TARGET-ar
export AS=$TOOLCHAIN/bin/$TARGET-as
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
export LD=$TOOLCHAIN/bin/$TARGET-ld
export RANLIB=$TOOLCHAIN/bin/$TARGET-ranlib
export STRIP=$TOOLCHAIN/bin/$TARGET-strip
./configure --prefix=$WORK_DIR/$I32NAME --host $TARGET
make
make install

#delete intermediate folder
cd ..

rm -rf $SOURCEDIR/
rmdir $SOURCEDIR

#x64*******************************************************************
tar xzf $SOURCEDIR.tar.gz
cd $SOURCEDIR

# Only choose one of these, depending on your build machine...
export TOOLCHAIN=$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64

# Only choose one of these, depending on your device...
export TARGET=x86_64-linux-android

# Configure and build.
export AR=$TOOLCHAIN/bin/$TARGET-ar
export AS=$TOOLCHAIN/bin/$TARGET-as
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
export LD=$TOOLCHAIN/bin/$TARGET-ld
export RANLIB=$TOOLCHAIN/bin/$TARGET-ranlib
export STRIP=$TOOLCHAIN/bin/$TARGET-strip
./configure --prefix=$WORK_DIR/$I64NAME --host $TARGET
make
make install

#delete intermediate folder
cd ..

rm -rf $SOURCEDIR/
rmdir $SOURCEDIR

#finish steps******************************************************

echo Now we need to install libtool for finish libs, please enter the sudo passwd!

sudo apt -y install libtool-bin

libtool --finish $WORK_DIR/$ARM64NAME/lib

libtool --finish $WORK_DIR/$ARM32NAME/lib

libtool --finish $WORK_DIR/$I64NAME/lib

libtool --finish $WORK_DIR/$I32NAME/lib

echo All done!

