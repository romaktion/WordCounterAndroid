#!/bin/bash

SOURCEDIR=libiconv-1.16
ARM32NAME=armeabi-v7a
ARM64NAME=arm64-v8a
I32NAME=x86
I64NAME=x86_64

#arm64-v8a*******************************************************************
tar xzf $SOURCEDIR.tar.gz
cd $SOURCEDIR

export NDK=$HOME/Android/android-ndk-r21b

# Only choose one of these, depending on your build machine...
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64

# Only choose one of these, depending on your device...
export TARGET=aarch64-linux-android
#export TARGET=armv7a-linux-androideabi
#export TARGET=i686-linux-android
#export TARGET=x86_64-linux-android

# Set this to your minSdkVersion.
export API=26

# Configure and build.
export AR=$TOOLCHAIN/bin/$TARGET-ar
export AS=$TOOLCHAIN/bin/$TARGET-as
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
export LD=$TOOLCHAIN/bin/$TARGET-ld
export RANLIB=$TOOLCHAIN/bin/$TARGET-ranlib
export STRIP=$TOOLCHAIN/bin/$TARGET-strip
./configure --prefix=/home/roman/tmp/$ARM64NAME --host $TARGET
make
make install

#delete intermediate folder
cd ..

rm -rf $SOURCEDIR/
rmdir $SOURCEDIR

#armeabi-v7a*******************************************************************
tar xzf libiconv-1.16.tar.gz
cd libiconv-1.16

export NDK=/home/roman/Android/android-ndk-r21b

# Only choose one of these, depending on your build machine...
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64

# Only choose one of these, depending on your device...
#export TARGET=aarch64-linux-android
export TARGET=armv7a-linux-androideabi
#export TARGET=i686-linux-android
#export TARGET=x86_64-linux-android

# Set this to your minSdkVersion.
export API=26

# Configure and build.
#export AR=$TOOLCHAIN/bin/$TARGET-ar
#export AS=$TOOLCHAIN/bin/$TARGET-as
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
#export LD=$TOOLCHAIN/bin/$TARGET-ld
#export RANLIB=$TOOLCHAIN/bin/$TARGET-ranlib
#export STRIP=$TOOLCHAIN/bin/$TARGET-strip
./configure --prefix=/home/roman/tmp/$ARM32NAME --host $TARGET
make
make install

#delete intermediate folder
cd ..

rm -rf $SOURCEDIR/
rmdir $SOURCEDIR

#x86*******************************************************************
tar xzf libiconv-1.16.tar.gz
cd libiconv-1.16

export NDK=/home/roman/Android/android-ndk-r21b

# Only choose one of these, depending on your build machine...
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64

# Only choose one of these, depending on your device...
#export TARGET=aarch64-linux-android
#export TARGET=armv7a-linux-androideabi
export TARGET=i686-linux-android
#export TARGET=x86_64-linux-android

# Set this to your minSdkVersion.
export API=26

# Configure and build.
export AR=$TOOLCHAIN/bin/$TARGET-ar
export AS=$TOOLCHAIN/bin/$TARGET-as
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
export LD=$TOOLCHAIN/bin/$TARGET-ld
export RANLIB=$TOOLCHAIN/bin/$TARGET-ranlib
export STRIP=$TOOLCHAIN/bin/$TARGET-strip
./configure --prefix=/home/roman/tmp/$I32NAME --host $TARGET
make
make install

#delete intermediate folder
cd ..

rm -rf $SOURCEDIR/
rmdir $SOURCEDIR

#x64*******************************************************************
tar xzf libiconv-1.16.tar.gz
cd libiconv-1.16

export NDK=/home/roman/Android/android-ndk-r21b

# Only choose one of these, depending on your build machine...
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64

# Only choose one of these, depending on your device...
#export TARGET=aarch64-linux-android
#export TARGET=armv7a-linux-androideabi
#export TARGET=i686-linux-android
export TARGET=x86_64-linux-android

# Set this to your minSdkVersion.
export API=26

# Configure and build.
export AR=$TOOLCHAIN/bin/$TARGET-ar
export AS=$TOOLCHAIN/bin/$TARGET-as
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
export LD=$TOOLCHAIN/bin/$TARGET-ld
export RANLIB=$TOOLCHAIN/bin/$TARGET-ranlib
export STRIP=$TOOLCHAIN/bin/$TARGET-strip
./configure --prefix=/home/roman/tmp/$I64NAME --host $TARGET
make
make install

#delete intermediate folder
cd ..

rm -rf $SOURCEDIR/
rmdir $SOURCEDIR

#finish steps******************************************************

echo Now we need to install libtool for finish libs, please enter the sudo passwd!

sudo apt-get -y install libtool

libtool --finish $ARM64NAME/lib

libtool --finish $ARM32NAME/lib

libtool --finish $I64NAME/lib

libtool --finish $I32NAME/lib

echo All done!

