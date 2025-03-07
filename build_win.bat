@echo off
setlocal EnableDelayedExpansion

REM Prepare the build with creating the file structure
mkdir upload
mkdir upload\include\mp4decrypt
mkdir upload\Debug
mkdir upload\Release
REM xcopy /s /e /h /i /y /q "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Redist\MSVC\14.29.30133" upload
REM exit /b
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

REM Copy over the built files
copy /y /v build\Debug\*.dll upload\Debug
copy /y /v build\Debug\mp4decrypt.lib upload\Debug\mp4decrypt_debug.lib
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
copy /y /v include upload\include\mp4decrypt

REM Copy the Debug version of the C Runtime from VS 2019 so we can use the Debug build in VS 2017
copy /y /v "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Redist\MSVC\14.29.30133\debug_nonredist\x64\Microsoft.VC142.DebugCRT\vcruntime140_1d.dll" upload\Debug

exit /b
