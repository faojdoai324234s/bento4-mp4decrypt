#!/bin/bash

# Prepare the build with creating the file structure
mkdir temp
mkdir upload
mkdir upload\include\mp4decrypt
mkdir upload\Debug
mkdir upload\Release

git clone https://github.com/axiomatic-systems/Bento4
ls
# Copy the source files which will be overwritten
cp src\*.cpp temp

# Copy over the source files from Bento4
cp "Bento4\Source\C++\Core\*.h" src
cp "Bento4\Source\C++\Core\*.cpp" src

cp "Bento4\Source\C++\Codecs\*.h" src
cp "Bento4\Source\C++\Codecs\*.cpp" src

cp "Bento4\Source\C++\Crypto\*.h" src
cp "Bento4\Source\C++\Crypto\*.cpp" src

# Copy back the files which were overwritten
cp temp\*.cpp src

cp "Bento4\Source\C++\MetaData\*.h" src
cp "Bento4\Source\C++\MetaData\*.cpp" src

# Configure CMake for Debug build
cmake -B build -DCMAKE_BUILD_TYPE=Debug

# Build CMake for Debug build
cmake --build build --config Debug

# Copy over the built files
# cp build\Debug\*.dll upload\Debug
# cp build\Debug\mp4decrypt.lib upload\Debug\mp4decrypt_debug.lib
# cp build\Debug\*.pdb upload\Debug

# Clean up before we run CMake again
rmdir /s /q build

# Configure CMake for Release build
cmake -B build -DCMAKE_BUILD_TYPE=Release

# Build CMake for Release build
cmake --build build --config Release

# Copy over the built files
# cp build\Release\*.dll upload\Release
# cp build\Release\*.lib upload\Release

# Copy over the headers
cp include upload\include\mp4decrypt
