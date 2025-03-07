@echo off
setlocal EnableDelayedExpansion

REM Prepare the build with creating the file structure
mkdir upload
mkdir upload\include
mkdir upload\Debug
mkdir upload\Release

git clone https://github.com/axiomatic-systems/Bento4

REM Copy over the source files from Bento4
copy /y /v "Bento4\Source\C++\Core\*.h" src
copy /y /v "Bento4\Source\C++\Core\*.cpp" src

copy /y /v "Bento4\Source\C++\Codecs\*.h" src
copy /y /v "Bento4\Source\C++\Codecs\*.cpp" src

copy /y /v "Bento4\Source\C++\Crypto\*.h" src
copy /y /v "Bento4\Source\C++\Crypto\*.cpp" src

copy /y /v "Bento4\Source\C++\MetaData\*.h" src
copy /y /v "Bento4\Source\C++\MetaData\*.cpp" src

REM Configure CMake for Debug build
cmake -B build -DCMAKE_BUILD_TYPE=Debug

REM Build CMake for Debug build
cmake --build build --config Debug

REM Rename the Debug files to avoid name clash when using both Debug and Release builds simultaneously
cd build\Debug
rename mp4decrypt.dll mp4decrypt_debug.dll
rename mp4decrypt.lib mp4decrypt_debug.lib
rename mp4decrypt.pdb mp4decrypt_debug.pdb

cd ..

REM Copy over the built files
copy /y /v build\Debug\*.dll upload\Debug
copy /y /v build\Debug\*.lib upload\Debug
copy /y /v build\Debug\*.pdb upload\Debug

REM Clean up before we run CMake again
rmdir /s /q build

REM Configure CMake for Release build
cmake -B build -DCMAKE_BUILD_TYPE=Release

REM Build CMake for Release build
cmake --build build --config Release

REM Copy over the built files
copy /y /v build\Release\*.dll upload\Release
copy /y /v build\Release\*.lib upload\Release

REM Copy over the headers
copy /y /v include upload\include

exit /b
