REM load toolset info
set TOOLSET_INFO_DIR=%PREFIX%\toolset-info
call "%TOOLSET_INFO_DIR%\common-vars-mingw.bat"

REM add missing dclspec
"%MSYS_PATH%\patch" -p0 -l -i "%RECIPE_DIR%\armadillo-win.patch"
if errorlevel 1 exit 1

mkdir build
cd build

if "%ARCH%"=="64" set ARMA_USE_64BIT_WORD=-DARMA_64BIT_WORD=1

%DOS_TOOLS% :to_linux_path "%LIBRARY_PREFIX%" LIBRARY_PREFIX_UNIX

cmake .. -G "%CMAKE_GENERATOR%" ^
         -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX_UNIX%" ^
         -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX_UNIX%" ^
         -DOpenBLAS_NAMES=libopenblas ^
         -DDETECT_HDF5=1 ^
         %ARMA_USE_64BIT_WORD%
if errorlevel 1 exit 1

set CONFIGURATION=Release
cmake --build . --target ALL_BUILD --config %CONFIGURATION%
if errorlevel 1 exit 1
cmake --build . --target INSTALL --config %CONFIGURATION%
if errorlevel 1 exit 1
