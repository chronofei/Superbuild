# Superbuild: A CMake project to build C++ dependencies for Slam libraries

This projects builds and installs locally C++ libraries, required for SLAM and Mapping projects of [MappingResearchKEU](https://gitlab.kitware.com/keu-computervision/MappingResearchKEU).

The dependencies available can be found in the file [CMakeLists.txt](https://gitlab.kitware.com/keu-computervision/MappingResearchKEU/Superbuild/-/blob/master/CMakeLists.txt).

# To build the project

### Ubuntu

To install all libraries locally, run the following commands in a bash console:

```bash
git clone https://gitlab.kitware.com/keu-computervision/MappingResearchKEU/Superbuild       # Clones the project locally
cd Superbuild                                                                               
./superbuild.sh                                                                             # Launch the superbuild
cd ../install                                                                               # Root directory of the superbuild installed libraries
```


### Windows (TODO)


## TODOs
 - [ ] Build instructions for Windows
 - [ ] Gitlab CI
 - [ ] Dependencies management
