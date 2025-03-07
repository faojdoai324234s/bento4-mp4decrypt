@echo off
setlocal EnableDelayedExpansion

mkdir build
mkdir upload
mkdir upload\include
mkdir upload\Debug

git clone https://github.com/axiomatic-systems/Bento4

copy /y /v "Bento4\Source\C++\Core\*.h" src
copy /y /v "Bento4\Source\C++\Core\*.cpp" src

copy /y /v "Bento4\Source\C++\Codecs\*.h" src
copy /y /v "Bento4\Source\C++\Codecs\*.cpp" src

copy /y /v "Bento4\Source\C++\Crypto\*.h" src
copy /y /v "Bento4\Source\C++\Crypto\*.cpp" src

copy /y /v "Bento4\Source\C++\MetaData\*.h" src
copy /y /v "Bento4\Source\C++\MetaData\*.cpp" src

REM Configure CMake
cmake -B build -DCMAKE_BUILD_TYPE=Debug

REM Build CMake
cmake --build build --config Debug

REM dir /s

copy /y /v build\Debug\*.dll upload\Debug
copy /y /v build\Debug\*.lib upload\Debug
copy /y /v build\Debug\*.pdb upload\Debug
copy /y /v include upload\include

del /f /s /q build

dir /s

exit /b
