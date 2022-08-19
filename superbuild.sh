#! /bin/bash

BUILD_TYPE=$1   #< Build type
INSTALL_DIR=$2  #< Install directory for the superbuild
CMAKE_ARGS=$3   #< All CMake arguments interpreted as a string

if [ -z "$BUILD_TYPE" ]
then BUILD_TYPE=Release
else
   if [ "$BUILD_TYPE" != "Release" ] && [ "$BUILD_TYPE" != "Debug" ] && [ "$BUILD_TYPE" != "RelWithDebInfo" ];
   then	echo "Build type $BUILD_TYPE not recognised (must be one of: Release, Debug, RelWithDebInfo)" && exit 1
   fi
fi

root_dir=$(cd ..; pwd)

# Setup a default install directory
if [ -z "$INSTALL_DIR" ]
then
  INSTALL_DIR=${root_dir}/install
  cmake -E make_directory $INSTALL_DIR
fi

install_dir=${INSTALL_DIR}
superbuild_build_dir=${root_dir}/cmake-build-Superbuild

if [ ! -d ${superbuild_build_dir} ]
then
   mkdir ${superbuild_build_dir}
fi 

check_status_code() {
   if [ $1 -ne 0 ]
   then
	echo "[Superbuild] Failure. Exiting."
	exit 1
   fi
}

cd ${superbuild_build_dir} || (echo "Failed to go in ${superbuild_build_dir}" && exit)

echo "[SUPERBUILD] -- Configuring the superbuild:"
echo "BUILD LOCATION=${superbuild_build_dir}"
echo "INSTALL_LOCATION=${install_dir}"
echo
cmake ../Superbuild -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DSUPERBUILD_INSTALL_DIR=${install_dir} $CMAKE_ARGS
check_status_code $?
cmake --build . --config $BUILD_TYPE --target install
check_status_code $?
