set BUILD_DIR=%~n0
set INSTALL_DIR=xerces-install-win32-2008-Debug
set cleanBuild=%1
if "%cleanBuild%"=="1" rd /Q /S %BUILD_DIR%

mkdir %BUILD_DIR% 
call cmake -B %BUILD_DIR% -S %~dp0 -G "Visual Studio 9 2008" -DCMAKE_INSTALL_PREFIX=%INSTALL_DIR%
call cmake --build %BUILD_DIR% --config Debug
call cmake --build %BUILD_DIR% --config Debug --target install
