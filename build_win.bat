@echo off
setlocal EnableDelayedExpansion

mkdir build
mkdir include
mkdir src

git clone https://github.com/axiomatic-systems/Bento4
 
copy /y /v "Bento4\Source\C++\Core\*.h" "src"
copy /y /v "Bento4\Source\C++\Core\*.cpp" "src"

copy /y /v "Bento4\Source\C++\Codecs\*.h" "src"
copy /y /v "Bento4\Source\C++\Codecs\*.cpp" "src"

copy /y /v "Bento4\Source\C++\Crypto\*.h" "src"
copy /y /v "Bento4\Source\C++\Crypto\*.cpp" "src"

del Bento4

REM Configure CMake
cmake -B build -DCMAKE_BUILD_TYPE=Debug

REM Build CMake
cmake --build build --config Debug

dir /s

exit /b
