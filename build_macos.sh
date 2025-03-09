#!/bin/bash

# Prepare the build with creating the file structure
mkdir temp
mkdir upload
mkdir upload/include
mkdir upload/include/mp4decrypt
mkdir upload/Debug
mkdir upload/Release

git clone https://github.com/axiomatic-systems/Bento4

# Copy the source files which will be overwritten
cp -r src/. temp

# Copy over the source files from Bento4
cp -r Bento4/Source/C++/Core/. src
cp -r Bento4/Source/C++/Codecs/. src
cp -r Bento4/Source/C++/Crypto/. src
cp -r Bento4/Source/C++/MetaData/. src

# Copy back the files which were overwritten
cp -r temp/. src

# Configure CMake for Debug build
cmake -B build -DCMAKE_BUILD_TYPE=Debug

# Build CMake for Debug build
cmake --build build --config Debug

# Copy over the built files
cp build/libmp4decrypt.dylib upload/Debug

# Clean up before we run CMake again
rm -rf build

# Configure CMake for Release build
cmake -B build -DCMAKE_BUILD_TYPE=Release

# Build CMake for Release build
cmake --build build --config Release

# Copy over the built files
cp build/libmp4decrypt.dylib upload/Release

# Copy over the headers
cp -r include/. upload/include/mp4decrypt
cp src/Ap4AesBlockCipher.cpp upload
