cmake_minimum_required(VERSION 3.14)
project(SLAM_Superbuild)


# -----------------------------------------------------------------------------------------------
# Select Options

option(DEFAULT_LIB_OPTION "The default option to build each library" ON)
option(DO_BUILD_ALWAYS "Whether to pass BUILD_ALWAYS option to ExternalProject_Add" OFF)
option(WITH_GLOG "Whether to install Glog" ${DEFAULT_LIB_OPTION})
option(WITH_EIGEN "Whether to install Eigen3" ${DEFAULT_LIB_OPTION})
option(WITH_CERES "Whether to install Ceres" ${DEFAULT_LIB_OPTION})
option(WITH_YAML_CPP "Whether to install YAML-CPP" ${DEFAULT_LIB_OPTION})
option(WITH_GTEST "Whether to install GTest" ${DEFAULT_LIB_OPTION})
option(WITH_VIZ3D "Whether to install viz3d dependencies" ${DEFAULT_LIB_OPTION})
option(WITH_CEREAL "Wether to install cereal dependency" ${DEFAULT_LIB_OPTION})
option(WITH_TCLAP "Wether to install TCLAP dependency" ${DEFAULT_LIB_OPTION})
option(WITH_TESSIL "Wether to install Tessil dependency" ${DEFAULT_LIB_OPTION})
option(WITH_SQLITE "Wether to install SQLITE dependency" ${DEFAULT_LIB_OPTION})
option(WITH_G2O "Wether to install g2O dependency" ${DEFAULT_LIB_OPTION})
option(WITH_OPENCV "Whether to install OpenCV dependency" ${DEFAULT_LIB_OPTION})
option(WITH_NANOFLANN "Whether to install nanoflann dependency" ${DEFAULT_LIB_OPTION})
option(WITH_COLORMAP "Whether to install colormap dependency" ${DEFAULT_LIB_OPTION})
option(WITH_TINYPLY "Whether to install tinyply dependency" ${DEFAULT_LIB_OPTION})
option(WITH_SPATIAL_INDEX "Whether to install spatial index dependency" ${DEFAULT_LIB_OPTION})
option(WITH_BOOST "Whether to install the boost dependency" ${DEFAULT_LIB_OPTION})

if (WITH_CERES)
    set(WITH_EIGEN ON)
    set(WITH_GLOG ON)
endif ()

# -----------------------------------------------------------------------------------------------
# Read CMAKE Arguments 

# -- Set c++ standard
if (NOT CMAKE_CXX_STANDARD)
    set(CMAKE_CXX_STANDARD 17)
endif ()
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if (NOT SUPERBUILD_INSTALL_DIR)
    set(SUPERBUILD_INSTALL_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../install_${CMAKE_BUILD_TYPE})
endif ()

include(ExternalProject)
include(superbuild.cmake)

set(LOG_PREFIX " [Superbuild] -- [Generation] -- ")

# -----------------------------------------------------------------------------------------------
# INSTALL Import files
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/superbuild_import.cmake.in ${SUPERBUILD_INSTALL_DIR}/superbuild_import.cmake @ONLY)

# -----------------------------------------------------------------------------------------------
# INSTALL GTEST 
if (WITH_GTEST)
    message(INFO "${LOG_PREFIX}Generating GTest dependency")
    ExternalProject_Add(
            gtest
            PREFIX gtest

            GIT_REPOSITORY https://github.com/google/googletest
            GIT_TAG release-1.11.0

            BUILD_ALWAYS ${DO_BUILD_ALWAYS}
            INSTALL_DIR ${GTEST_INSTALL_DIR}
            CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX=${GTEST_INSTALL_DIR}
            -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}

            STEP_TARGETS install
            BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --config ${CMAKE_BUILD_TYPE} --target install --parallel 6)

endif ()


# -----------------------------------------------------------------------------------------------
# INSTALL GLOG

if (WITH_GLOG)
    message(INFO "${LOG_PREFIX}Generating GLOG dependency")
    set(GLOG_DEF "glog")
    ExternalProject_Add(
            ${GLOG_DEF}
            PREFIX ${GLOG_DEF}

            GIT_REPOSITORY https://github.com/google/glog
            GIT_TAG v0.5.0

            BUILD_ALWAYS ${DO_BUILD_ALWAYS}
            INSTALL_DIR ${GLOG_INSTALL_DIR}
            CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX=${GLOG_INSTALL_DIR}
            -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}

            STEP_TARGETS install
            BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --config ${CMAKE_BUILD_TYPE} --target install --parallel 6)
endif ()

# -----------------------------------------------------------------------------------------------
# INSTALL Eigen3

if (WITH_EIGEN)

    message(INFO "${LOG_PREFIX}Generating Eigen3 dependency")
    # INSTALL EIGEN
    ExternalProject_Add(
            Eigen3_ext
            PREFIX Eigen3_ext

            GIT_REPOSITORY https://gitlab.com/libeigen/eigen
            GIT_TAG 3.4.0

            BUILD_ALWAYS ${DO_BUILD_ALWAYS}
            INSTALL_DIR ${EIGEN3_INSTALL_DIR}
            CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX=${EIGEN3_INSTALL_DIR}
            -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}

            STEP_TARGETS install
            BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --config ${CMAKE_BUILD_TYPE} --parallel 6)

endif ()

# -----------------------------------------------------------------------------------------------
# INSTALL Ceres 
if (WITH_CERES)
    message(INFO "${LOG_PREFIX}Generating Ceres dependency")

    ExternalProject_Add(
            Ceres
            PREFIX Ceres

            GIT_REPOSITORY https://ceres-solver.googlesource.com/ceres-solver
            GIT_TAG 2.1.0

            BUILD_ALWAYS ${DO_BUILD_ALWAYS}
            INSTALL_DIR ${CERES_INSTALL_DIR}
            CMAKE_ARGS
            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            -DCMAKE_POSITION_INDEPENDENT_CODE=ON
            -DCMAKE_INSTALL_PREFIX=${CERES_INSTALL_DIR}
            -DBUILD_TESTING=OFF
            -DBUILD_EXAMPLES=OFF
            -DPROVIDE_UNINSTALL_TARGET=OFF
            -DEIGENSPARSE=ON
            -DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON
            -DEigen3_DIR=${EIGEN3_INSTALL_DIR}/share/eigen3/cmake
            -DGLOG_INCLUDE_DIR=${GLOG_INSTALL_DIR}/include
            -DGLOG_LIBRARY=${GLOG_INSTALL_DIR}/lib
            -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}
            -DBUILD_SHARED_LIBS=ON

            DEPENDS ${GLOG_DEF}-install Eigen3_ext-install Eigen3_ext
            BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --config ${CMAKE_BUILD_TYPE} --target install --parallel 6)
endif ()

# -----------------------------------------------------------------------------------------------
# INSTALL YAML-CPP
if (WITH_YAML_CPP)

    message(INFO "${LOG_PREFIX}Generating yaml-cpp dependency")

    ExternalProject_Add(
            yaml-cpp
            PREFIX yaml-cpp

            GIT_REPOSITORY https://github.com/jbeder/yaml-cpp
            GIT_TAG yaml-cpp-0.6.3

            BUILD_ALWAYS ${DO_BUILD_ALWAYS}
            INSTALL_DIR ${YAML_INSTALL_DIR}
            CMAKE_ARGS
            -DYAML_BUILD_SHARED_LIBS=ON
            -DCMAKE_INSTALL_PREFIX=${YAML_INSTALL_DIR}
            -DYAML_CPP_BUILD_TESTS=OFF
            -DYAML_CPP_BUILD_TOOLS=OFF
            -DYAML_CPP_BUILD_CONTRIB=OFF
            -DYAML_CPP_BUILD_TESTS=OFF

            DEPENDS
            BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --config ${CMAKE_BUILD_TYPE} --parallel 6)
endif ()

# -----------------------------------------------------------------------------------------------
if (WITH_VIZ3D)
    message(INFO "${LOG_PREFIX}Generating viz3d dependency")

    if (WITH_GLOG)
        set(VIZ3D_BUILD_GLOG OFF)
    else ()
        set(VIZ3D_BUILD_GLOG ON)
    endif ()

    if (WITH_EIGEN)
        set(VIZ3D_BUILD_EIGEN OFF)
    else ()
        set(VIZ3D_BUILD_EIGEN ON)
    endif ()


    # Add viz3d and configure the Superbuild (Generation and Build)
    ExternalProject_Add(
            viz3d
            PREFIX viz3d

            GIT_REPOSITORY https://github.com/pierdell/viz3d
            GIT_TAG dev

            BUILD_ALWAYS ${DO_BUILD_ALWAYS}
            INSTALL_DIR ${VIZ3D_SUPERBUILD_DIR}
            CMAKE_ARGS
            DEPENDS

            CONFIGURE_COMMAND ""
            COMMAND ${CMAKE_COMMAND} -DCMAKE_INSTALL_PREFIX=${VIZ3D_SUPERBUILD_DIR} -DBUILD_GLOG=${VIZ3D_BUILD_GLOG} -DBUILD_EIGEN=${VIZ3D_BUILD_EIGEN} -DINSTALL_DIR=${VIZ3D_SUPERBUILD_DIR} -DINSTALL_ROOT=${VIZ3D_SUPERBUILD_DIR} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            -S <SOURCE_DIR>/external -B <BINARY_DIR>/external
            COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR>/external --config ${CMAKE_BUILD_TYPE} --parallel 6


            BUILD_COMMAND ""
            COMMAND ${CMAKE_COMMAND} -DCMAKE_INSTALL_PREFIX=${VIZ3D_SUPERBUILD_DIR} -DBUILD_GLOG=${VIZ3D_BUILD_GLOG} -DBUILD_EIGEN=${VIZ3D_BUILD_EIGEN} -DINSTALL_DIR=${VIZ3D_SUPERBUILD_DIR} -DINSTALL_ROOT=${VIZ3D_SUPERBUILD_DIR} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            -S <SOURCE_DIR> -B <BINARY_DIR>
            COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --config ${CMAKE_BUILD_TYPE} --parallel 6 --target install


            INSTALL_COMMAND "")


endif ()

# -----------------------------------------------------------------------------------------------
if (WITH_CEREAL)
    message(INFO "${LOG_PREFIX}Generating cereal dependency")

    ExternalProject_Add(
            cereal
            PREFIX cereal

            GIT_REPOSITORY https://github.com/USCiLab/cereal
            GIT_TAG v1.3.0

            BUILD_ALWAYS ${DO_BUILD_ALWAYS}
            INSTALL_DIR ${CEREAL_INSTALL_DIR}
            CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX=${CEREAL_INSTALL_DIR}
            -DJUST_INSTALL_CEREAL=ON
            -DSKIP_PORTABILITY_TEST=ON
            -DSKIP_PERFORMANCE_COMPARISON=ON
            -DCMAKE_POSITION_INDEPENDENT_CODE=ON
            -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}

            BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --config ${CMAKE_BUILD_TYPE} --target install --parallel 6)

endif ()


# -----------------------------------------------------------------------------------------------
if (WITH_TESSIL)
    message(INFO "${LOG_PREFIX}Generating tessil dependency")
    ExternalProject_Add(
            tessil
            PREFIX tessil

            GIT_REPOSITORY https://github.com/Tessil/robin-map
            GIT_TAG v0.6.3

            BUILD_ALWAYS ${DO_BUILD_ALWAYS}
            INSTALL_DIR ${TESSIL_INSTALL_DIR}
            CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX=${TESSIL_INSTALL_DIR}
            -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}
            -DCMAKE_POSITION_INDEPENDENT_CODE=ON
            BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --config ${CMAKE_BUILD_TYPE} --target install --parallel 6)
endif ()

# -----------------------------------------------------------------------------------------------
if (WITH_G2O)
    message(INFO "${LOG_PREFIX}Generating G2O dependency")

    if (NOT G2O_EIGEN_CMAKE_DIR)
        if (NOT WITH_EIGEN)
            message(FATAL_ERROR "To build G2O in the superbuild you must also build Eigen or provide the path to an installed version")
        endif ()
        set(G2O_EIGEN_CMAKE_DIR ${EIGEN3_INSTALL_DIR}/share/eigen3/cmake)
        message(INFO "${LOG_PREFIX}Setting the variable G2O_EIGEN_CMAKE_DIR=${EIGEN_CMAKE_DIR}")
    endif ()

    ExternalProject_Add(
            g2o
            PREFIX g2o

            GIT_REPOSITORY https://github.com/RainerKuemmerle/g2o
            GIT_TAG master

            BUILD_ALWAYS ${DO_BUILD_ALWAYS}
            INSTALL_DIR ${G2O_INSTALL_DIR}
            CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX=${G2O_INSTALL_DIR}
            -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}
            -DCMAKE_POSITION_INDEPENDENT_CODE=ON
            -DEigen3_DIR=${G2O_EIGEN_CMAKE_DIR}
            BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --config ${CMAKE_BUILD_TYPE} --target install --parallel 6

            DEPENDS Eigen3_ext-install Eigen3_ext)
endif ()

# -----------------------------------------------------------------------------------------------
if (WITH_NANOFLANN)
    message(INFO "${LOG_PREFIX}Generating nanoflann dependency")
    ExternalProject_Add(
            nanoflann
            PREFIX nanoflann

            GIT_REPOSITORY https://github.com/jlblancoc/nanoflann
            GIT_TAG v1.4.1

            BUILD_ALWAYS ${DO_BUILD_ALWAYS}
            INSTALL_DIR ${NANOFLANN_INSTALL_DIR}

            CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX=${NANOFLANN_INSTALL_DIR}
            -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}
            -DNANOFLANN_BUILD_EXAMPLES=OFF
            BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --config ${CMAKE_BUILD_TYPE} --target install --parallel 6)
endif ()

# -----------------------------------------------------------------------------------------------
if (WITH_SPATIAL_INDEX)
    message(INFO "${LOG_PREFIX}Generating spatialindex dependency")
    ExternalProject_Add(
            spatialindex
            PREFIX spatialindex

            GIT_REPOSITORY https://github.com/libspatialindex/libspatialindex
            GIT_TAG 8ee2236

            BUILD_ALWAYS ${DO_BUILD_ALWAYS}
            INSTALL_DIR ${SPATIAL_INDEX_INSTALL_DIR}

            CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX=${SPATIAL_INDEX_INSTALL_DIR}
            -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}
            BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --config ${CMAKE_BUILD_TYPE} --target install --parallel 6)
endif ()


# -----------------------------------------------------------------------------------------------
if (WITH_OPENCV)
    message(INFO "${LOG_PREFIX}Generating OpenCV dependency")
    if (NOT OPENCV_INSTALL_DIR)
        message(FATAL_ERROR "${LOG_PREFIX} The cmake variable ${OPENCV_INSTALL_DIR} does not exist")
    endif ()


    if (NOT EIGEN_CMAKE_DIR)
        if (NOT WITH_EIGEN)
            message(FATAL_ERROR "To build G2O in the superbuild you must also build Eigen or provide the path to an installed version")
        endif ()
        set(G2O_EIGEN_CMAKE_DIR ${EIGEN3_INSTALL_DIR}/share/eigen3/cmake)
        message(INFO "${LOG_PREFIX}Setting the variable G2O_EIGEN_CMAKE_DIR=${EIGEN_CMAKE_DIR}")
    endif ()

    set(OPENCV_VERSION 4.5.3)
    ExternalProject_Add(
            opencv_contrib
            PREFIX opencv_contrib
            GIT_REPOSITORY https://github.com/opencv/opencv_contrib
            GIT_TAG ${OPENCV_VERSION}

            BUILD_ALWAYS ${DO_BUILD_ALWAYS}
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ""
            INSTALL_COMMAND "")

    set(OPENCV_CMAKE_ARGS
            -DCMAKE_POSITION_INDEPENDENT_CODE=ON
            -DCMAKE_INSTALL_PREFIX=${OPENCV_INSTALL_DIR}
            -DCMAKE_CXX_STANDARD=14
            -DOPENCV_EXTRA_MODULES_PATH=${CMAKE_CURRENT_BINARY_DIR}/opencv_contrib/src/opencv_contrib/modules)


    if (WITH_EIGEN)
        set(OPENCV_EIGEN3_INCLUDE_PATH ${EIGEN3_INSTALL_DIR}/include/eigen3)
        message(INFO "${LOG_PREFIX}Setting the Cmake variable OPENCV_EIGEN3_INCLUDE_PATH=${OPENCV_EIGEN3_INCLUDE_PATH}")
        set(OPENCV_CMAKE_ARGS
                ${OPENCV_CMAKE_ARGS}
                -DWITH_EIGEN=ON
                -DEIGEN_INCLUDE_PATH=${OPENCV_EIGEN3_INCLUDE_PATH})
    endif ()

    # INSTALL OpenCV
    ExternalProject_Add(
            opencv
            PREFIX opencv

            GIT_REPOSITORY https://github.com/opencv/opencv
            GIT_TAG ${OPENCV_VERSION}

            BUILD_ALWAYS ${DO_BUILD_ALWAYS}

            INSTALL_DIR ${OPENCV_INSTALL_DIR}
            CMAKE_ARGS ${OPENCV_CMAKE_ARGS}
            BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --config ${CMAKE_BUILD_TYPE} --target install --parallel 8
            DEPENDS opencv_contrib)

endif ()


# -----------------------------------------------------------------------------------------------
if (WITH_BOOST)
    message(INFO "${LOG_PREFIX}Generating the boost dependency")
    if (NOT BOOST_INSTALL_DIR)
        message(FATAL_ERROR "${LOG_PREFIX} The cmake variable ${BOOST_INSTALL_DIR} does not install")
    endif ()

    set(boost_options link=shared --prefix=${BOOST_INSTALL_DIR})

    set(BOOST_CONFIGURE_COMMAND)
    if (WIN32)
        set(BOOST_CONFIGURE_COMMAND <SOURCE_DIR>/bootstrap.bat --prefix=${BOOST_INSTALL_DIR})
    else ()
        set(BOOST_CONFIGURE_COMMAND <SOURCE_DIR>/bootstrap.sh --prefix=${BOOST_INSTALL_DIR})
    endif ()

    # INSTALL boost
    ExternalProject_Add(
            boost
            PREFIX boost

            GIT_REPOSITORY https://github.com/boostorg/boost
            GIT_TAG boost-1.78.0

            BUILD_ALWAYS ${DO_BUILD_ALWAYS}
            BUILD_IN_SOURCE 1
            INSTALL_DIR ${BOOST_INSTALL_DIR}

            CONFIGURE_COMMAND ${BOOST_CONFIGURE_COMMAND}
            BUILD_COMMAND <SOURCE_DIR>/b2 ${boost_options}
            INSTALL_COMMAND <BINARY_DIR>/b2 ${boost_options} install)
endif ()


# -----------------------------------------------------------------------------------------------
# -- DEPENDENCIES REQUIRING CONFIGURATION GENERATIONS
include(CMakePackageConfigHelpers)
include(FetchContent)
set(CMAKE_INSTALL_PREFIX ${SUPERBUILD_INSTALL_DIR})

macro(SUPERBUILD_INSTALL_TARGET)
    if (NOT HDR_EXT)
        set(HDR_EXT "h")
    endif ()
    set(on_value_args TARGET TARGET_PREFIX INCLUDE_DIRECTORY INSTALL_DIRECTORY INSTALL_INCLUDE_SUFFIX)
    cmake_parse_arguments(SLAM "" "${on_value_args}" "" ${ARGN})

    if (NOT SLAM_INSTALL_INCLUDE_SUFFIX)
        set(SLAM_INSTALL_INCLUDE_SUFFIX ${SLAM_TARGET}/include)
    endif ()

    configure_package_config_file(${CMAKE_CURRENT_SOURCE_DIR}/template_config.cmake.in
            ${CMAKE_CURRENT_BINARY_DIR}/${SLAM_TARGET}Config.cmake
            INSTALL_DESTINATION ${SLAM_INSTALL_DIRECTORY}/lib/cmake)

    install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${SLAM_TARGET}Config.cmake"
            DESTINATION ${SLAM_TARGET}/lib/cmake)
    install(TARGETS ${SLAM_TARGET} DESTINATION ${SLAM_TARGET}/lib EXPORT ${SLAM_TARGET}Targets)
    install(EXPORT ${SLAM_TARGET}Targets
            NAMESPACE ${SLAM_TARGET_PREFIX}::
            DESTINATION "${SLAM_TARGET}/lib/cmake")

    install(DIRECTORY ${SLAM_INCLUDE_DIRECTORY} DESTINATION ${SLAM_INSTALL_INCLUDE_SUFFIX} FILES_MATCHING PATTERN "*.${HDR_EXT}")
endmacro(SUPERBUILD_INSTALL_TARGET)


# -----------------------------------------------------------------------------------------------
if (WITH_SQLITE)
    message(INFO "${LOG_PREFIX}Generating sqlite dependency")
    # EXTERNAL: SQLITE
    FetchContent_Declare(sqlite3 URL "https://sqlite.org/2021/sqlite-amalgamation-3350400.zip")
    if (NOT sqlite3_POPULATED)
        # notice that we do not call `add_subdirectory`, we simply fetch and then
        # use the subdirectory sources directly.
        FetchContent_Populate(sqlite3)
    endif ()

    set(SQLITE_SOURCE_INCLUDE_DIR ${sqlite3_SOURCE_DIR})
    set(SQLITE_INSTALL_INCLUDE_DIR ${SQLITE_INSTALL_DIR}/include)

    file(GLOB SQLITE_SOURCES "${sqlite3_SOURCE_DIR}/*")
    file(GLOB SQLITE_HEADERS "${sqlite3_SOURCE_DIR}/*.h")

    # Build the library and setup the include dir
    add_library(sqlite3 SHARED "${SQLITE_SOURCES}")
    target_include_directories(sqlite3 INTERFACE
            "$<BUILD_INTERFACE:${SQLITE_SOURCE_INCLUDE_DIR}>"
            "$<INSTALL_INTERFACE:${SQLITE_INSTALL_INCLUDE_DIR}>")

    SUPERBUILD_INSTALL_TARGET(TARGET sqlite3
            TARGET_PREFIX sqlite3
            INCLUDE_DIRECTORY ${SQLITE_SOURCE_INCLUDE_DIR}/
            INSTALL_DIRECTORY ${SQLITE_INSTALL_DIR})
endif ()


if (WITH_TCLAP)
    message(INFO "${LOG_PREFIX}Generating tclap dependency")

    # TCLAP For argument reader
    FetchContent_Declare(
            tclap
            GIT_REPOSITORY https://github.com/mirror/tclap
            GIT_TAG 1.4)

    FetchContent_GetProperties(tclap)
    if (NOT tclap_POPULATED)
        # Import Only TCLAP Header library (Without the unit tests)
        FetchContent_Populate(tclap)
    endif ()

    set(TCLAP_SOURCE_INCLUDE_DIR ${tclap_SOURCE_DIR}/include)
    set(TCLAP_INSTALL_INCLUDE_DIR ${TCLAP_INSTALL_DIR}/include)
    file(GLOB TCLAP_HEADERS "${tclap_SOURCE_DIR}/include/tclap/*.h")

    # Build the library and setup the include dir
    add_library(tclap INTERFACE)
    target_include_directories(tclap INTERFACE
            "$<INSTALL_INTERFACE:${TCLAP_INSTALL_INCLUDE_DIR}>")

    SUPERBUILD_INSTALL_TARGET(TARGET tclap
            TARGET_PREFIX tclap
            INCLUDE_DIRECTORY ${TCLAP_SOURCE_INCLUDE_DIR}/tclap
            INSTALL_DIRECTORY ${TCLAP_INSTALL_DIR})
endif ()

if (WITH_COLORMAP)
    message(INFO "${LOG_PREFIX}Generating colormap dependency")

    FetchContent_Declare(
            colormap
            GIT_REPOSITORY https://github.com/jgreitemann/colormap
            GIT_TAG 89ca7df)

    FetchContent_GetProperties(colormap)
    if (NOT colormap_POPULATED)
        FetchContent_Populate(colormap)
    endif ()

    set(colormap_SOURCE_INCLUDE_DIR ${colormap_SOURCE_DIR}/include)
    set(colormap_INSTALL_INCLUDE_DIR ${COLORMAP_INSTALL_DIR}/include)

    add_library(colormap INTERFACE)
    target_include_directories(colormap INTERFACE
            $<INSTALL_INTERFACE:${colormap_INSTALL_INCLUDE_DIR}>)
    set(HDR_EXT "hpp")
    SUPERBUILD_INSTALL_TARGET(TARGET colormap
            TARGET_PREFIX colormap
            INCLUDE_DIRECTORY ${colormap_SOURCE_INCLUDE_DIR}/colormap
            INSTALL_DIRECTORY ${COLORMAP_INSTALL_DIR})
endif ()

# -----------------------------------------------------------------------------------------------
if (WITH_TINYPLY)
    message(INFO "${LOG_PREFIX}Generating tinyply dependency")
    if (NOT TINYPLY_INSTALL_DIR)
        message(FATAL_ERROR "${LOG_PREFIX} The cmake variable ${TINYPLY_INSTALL_DIR} does not exist")
    endif ()

    FetchContent_Declare(
            tinyply
            GIT_REPOSITORY https://github.com/ddiakopoulos/tinyply
            GIT_TAG 2.4)

    FetchContent_GetProperties(tinyply)
    if (NOT tinyply_POPULATED)
        FetchContent_Populate(tinyply)
    endif ()

    set(tinyply_SOURCE_INCLUDE_DIR ${tinyply_SOURCE_DIR}/source)
    set(tinyply_INSTALL_INCLUDE_DIR ${TINYPLY_INSTALL_DIR}/include)

    add_library(tinyply SHARED ${tinyply_SOURCE_DIR}/source/tinyply.cpp)
    target_include_directories(tinyply INTERFACE
            $<INSTALL_INTERFACE:${tinyply_INSTALL_INCLUDE_DIR}>)
    set(HDR_EXT "h")
    SUPERBUILD_INSTALL_TARGET(TARGET tinyply
            TARGET_PREFIX tinyply
            INCLUDE_DIRECTORY ${tinyply_SOURCE_INCLUDE_DIR}/
            INSTALL_DIRECTORY ${TINYPLY_INSTALL_DIR}
            INSTALL_INCLUDE_SUFFIX tinyply/include/tinyply)
endif ()
