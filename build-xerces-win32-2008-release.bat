set BUILD_DIR=%~n0
set INSTALL_DIR=xerces-install-win32-2008-Release
set cleanBuild=%1
if "%cleanBuild%"=="1" rd /Q /S %BUILD_DIR%

mkdir %BUILD_DIR% 
call cmake -B %BUILD_DIR% -S %~dp0 -G "Visual Studio 9 2008" -DCMAKE_INSTALL_PREFIX=%INSTALL_DIR%
call cmake --build %BUILD_DIR% --config Release
call cmake --build %BUILD_DIR% --config Release --target install
