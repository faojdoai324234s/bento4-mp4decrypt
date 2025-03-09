#!/bin/bash

# Prepare the build with creating the file structure
mkdir temp
mkdir upload
mkdir upload\include\mp4decrypt
mkdir upload\Debug
mkdir upload\Release

git clone https://github.com/axiomatic-systems/Bento4

# Copy the source files which will be overwritten
copy src\*.cpp temp

# Copy over the source files from Bento4
copy /y /v "Bento4\Source\C++\Core\*.h" src
copy /y /v "Bento4\Source\C++\Core\*.cpp" src

copy /y /v "Bento4\Source\C++\Codecs\*.h" src
copy /y /v "Bento4\Source\C++\Codecs\*.cpp" src

copy /y /v "Bento4\Source\C++\Crypto\*.h" src
copy /y /v "Bento4\Source\C++\Crypto\*.cpp" src

# Copy back the files which were overwritten
copy /y /v temp\*.cpp src

copy /y /v "Bento4\Source\C++\MetaData\*.h" src
copy /y /v "Bento4\Source\C++\MetaData\*.cpp" src

# Configure CMake for Debug build
cmake -B build -DCMAKE_BUILD_TYPE=Debug

# Build CMake for Debug build
cmake --build build --config Debug

# Copy over the built files
# copy /y /v build\Debug\*.dll upload\Debug
# copy /y /v build\Debug\mp4decrypt.lib upload\Debug\mp4decrypt_debug.lib
# copy /y /v build\Debug\*.pdb upload\Debug

# Clean up before we run CMake again
rmdir /s /q build

# Configure CMake for Release build
cmake -B build -DCMAKE_BUILD_TYPE=Release

# Build CMake for Release build
cmake --build build --config Release

# Copy over the built files
# copy /y /v build\Release\*.dll upload\Release
# copy /y /v build\Release\*.lib upload\Release

# Copy over the headers
copy /y /v include upload\include\mp4decrypt
