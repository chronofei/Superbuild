# 
# This cmake script file set 
#

# -- Set build type
if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif ()

# -- Set install path
if (NOT SUPERBUILD_INSTALL_DIR)
    message(FATAL_ERROR " [Superbuild] -- the variable SUPERBUILD_INSTALL_DIR must be set before including this script.")
endif ()


# -------------------------------------------
# GLOG
if (NOT GLOG_INSTALL_DIR)
    set(GLOG_INSTALL_DIR ${SUPERBUILD_INSTALL_DIR}/glog)
endif ()

# -------------------------------------------
# GTEST 
if (NOT GTEST_INSTALL_DIR)
    set(GTEST_INSTALL_DIR ${SUPERBUILD_INSTALL_DIR}/googletest)
endif ()


# -------------------------------------------
# EIGEN3 
if (NOT EIGEN3_INSTALL_DIR)
    set(EIGEN3_INSTALL_DIR ${SUPERBUILD_INSTALL_DIR}/Eigen3)
endif ()

# -------------------------------------------
# CERES
if (NOT CERES_INSTALL_DIR)
    set(CERES_INSTALL_DIR ${SUPERBUILD_INSTALL_DIR}/Ceres)
endif ()

# -------------------------------------------
# YAML-CPP
if (NOT YAML_INSTALL_DIR)
    set(YAML_INSTALL_DIR ${SUPERBUILD_INSTALL_DIR}/yaml-cpp)
endif ()

# -------------------------------------------
# GLAD
if (NOT GLAD_INSTALL_DIR)
    set(GLAD_INSTALL_DIR ${SUPERBUILD_INSTALL_DIR}/glad)
endif ()

# -------------------------------------------
# GLFW 
if (NOT GLFW_INSTALL_DIR)
    set(GLFW_INSTALL_DIR ${SUPERBUILD_INSTALL_DIR}/glfw)
endif ()

# -------------------------------------------
# VIZ3D_SUPERBUILD_DIR
if (NOT VIZ3D_SUPERBUILD_DIR)
    set(VIZ3D_SUPERBUILD_DIR ${SUPERBUILD_INSTALL_DIR})
endif ()

# -------------------------------------------
# VIZ3D_INSTALL_DIR
if (NOT VIZ3D_DIR)
    set(VIZ3D_DIR ${VIZ3D_SUPERBUILD_DIR}/viz3d)
endif ()

# -------------------------------------------
# CEREAL_INSTALL_DIR
if (NOT CEREAL_INSTALL_DIR)
    set(CEREAL_INSTALL_DIR ${SUPERBUILD_INSTALL_DIR}/cereal)
endif ()

# -------------------------------------------
# TESSIL_INSTALL_DIR
if (NOT TESSIL_INSTALL_DIR)
    set(TESSIL_INSTALL_DIR ${SUPERBUILD_INSTALL_DIR}/tessil)
endif ()

# -------------------------------------------
# TCLAP_INSTALL_DIR
if (NOT TCLAP_INSTALL_DIR)
    set(TCLAP_INSTALL_DIR ${SUPERBUILD_INSTALL_DIR}/tclap)
endif ()

# -------------------------------------------
# SQLITE_INSTALL_DIR
if (NOT SQLITE_INSTALL_DIR)
    set(SQLITE_INSTALL_DIR ${SUPERBUILD_INSTALL_DIR}/sqlite3)
endif ()

# -------------------------------------------
# G2O_INSTALL_DIR
if (NOT G2O_INSTALL_DIR)
    set(G2O_INSTALL_DIR ${SUPERBUILD_INSTALL_DIR}/g2o)
endif ()

# -------------------------------------------
# OPENCV_INSTALL_DIR
if (NOT OPENCV_INSTALL_DIR)
    set(OPENCV_INSTALL_DIR ${SUPERBUILD_INSTALL_DIR}/opencv)
endif ()

# -------------------------------------------
# NANOFLANN_INSTALL_DIR
if (NOT NANOFLANN_INSTALL_DIR)
    set(NANOFLANN_INSTALL_DIR ${SUPERBUILD_INSTALL_DIR}/nanoflann)
endif ()

# -------------------------------------------
# COLORMAP_INSTALL_DIR
if (NOT COLORMAP_INSTALL_DIR)
    set(COLORMAP_INSTALL_DIR ${SUPERBUILD_INSTALL_DIR}/colormap)
endif ()

# -------------------------------------------
# TINYPLY_INSTALL_DIR
if (NOT TINYPLY_INSTALL_DIR)
    set(TINYPLY_INSTALL_DIR ${SUPERBUILD_INSTALL_DIR}/tinyply)
endif ()

# -------------------------------------------
# SPATIAL_INDEX_INSTALL_DIR
if (NOT SPATIAL_INDEX_INSTALL_DIR)
    set(SPATIAL_INDEX_INSTALL_DIR ${SUPERBUILD_INSTALL_DIR}/spatialindex)
endif ()

# -------------------------------------------
# BOOST
if (NOT BOOST_INSTALL_DIR)
    set(BOOST_INSTALL_DIR ${SUPERBUILD_INSTALL_DIR}/boost)
endif ()

# TODO:
#  - pybind11
#  -

