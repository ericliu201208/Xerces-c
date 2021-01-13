set BUILD_DIR=%~n0
set INSTALL_DIR=xerces-install-stellar-Debug
set cleanBuild=%1
if "%cleanBuild%"=="1" rd /Q /S %BUILD_DIR%

mkdir %BUILD_DIR%

call conan install . -if %BUILD_DIR%/deplibs -s compiler="Visual Studio" -s compiler.version=9 -s build_type=None -s compiler.runtime=MD -s arch=armv7 -s os=WindowsCE -s os.platform=ANY -s os.version=7.0

call cmake -B %BUILD_DIR% -S %~dp0 -G "Visual Studio 9 2008 Stellar_EC7 (ARMv4I)"  -DCMAKE_INSTALL_PREFIX=%~dp0/%INSTALL_DIR%/ -DCMAKE_PREFIX_PATH=%~dp0/%BUILD_DIR%/deplibs

call cmake --build %BUILD_DIR% --config Debug
call cmake --build %BUILD_DIR% --config Debug --target install