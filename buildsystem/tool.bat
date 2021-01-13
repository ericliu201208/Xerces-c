@echo off
setlocal

:: Reset ERRORLEVEL
type nul

set cmd=%1
set target=%2
set runtime_linkage=%3
set rootdir=%4

if "%runtime_linkage%"=="" (set runtime_linkage=shared)

set SCRIPTDIR=%~dp0
set SCRIPTDIR=%SCRIPTDIR:~0,-1%

call %SCRIPTDIR%\settings.bat

set conan_user=leica
set conan_channel=stable

set build_base_dir=%rootdir%\build\%target%
set build_dir=%build_base_dir%\build-%runtime_linkage%
set output_dir=%build_base_dir%\output
set install_dir=%build_base_dir%\install

if "%cmd%" == "build" (
	call :cleanup || exit /B 1
	call :create || exit /B 1
	call :build_install Release || exit /B 1
	call :build_install Debug || exit /B 1
	exit /B 0
)

if "%cmd%" == "export" (
	call :export || exit /B 1
	exit /B 0
)

echo ERROR: invalid command: %cmd%
echo exit.
exit /B 1


:cmake_option_runtime_shared
	if "%~1"=="shared" (
		set %~2=TRUE
	) else (
		set %~2=FALSE
	)
	exit /B 0

:conan_option_runtime_shared
	if "%~1"=="shared" (
		set %~2=True
	) else (
		set %~2=False
	)
	exit /B 0

:create
	setlocal
	call :cmake_option_runtime_shared %runtime_linkage% option_runtime_shared
	%project_utils_bin% ^
		create ^
		--root-dir %rootdir% ^
		--target %target% ^
		--build-dir %build_dir% ^
		--output-dir %output_dir% ^
		--install-prefix %install_dir% ^
		--cmake-bin %cmake_bin% ^
		--conan-bin %conan_bin% ^
		--extra-cmake-args="-DRUNTIME_SHARED=%option_runtime_shared% -DCMAKE_PREFIX_PATH=%output_dir%" ^
	|| exit /B 1

	exit /B 0

:build_install
	setlocal
	set build_type=%~1
	%project_utils_bin% ^
		build ^
		--root-dir %rootdir% ^
		--target %target% ^
		--build-type %build_type% ^
		--build-dir %build_dir% ^
		--cmake-bin %cmake_bin% ^
	|| exit /B 1

	%project_utils_bin% ^
		install ^
		--root-dir %rootdir% ^
		--target %target% ^
		--build-type %build_type% ^
		--build-dir %build_dir% ^
		--cmake-bin %cmake_bin% ^
	|| exit /B 1

	exit /B 0

:export
	setlocal
	call :conan_option_runtime_shared %runtime_linkage% option_runtime_shared

	%project_utils_bin% ^
		export ^
		--root-dir %rootdir% ^
		--target %target% ^
		--build-dir %build_dir% ^
		--install-prefix %install_dir% ^
		--conan-bin %conan_bin% ^
		--user %conan_user% ^
		--channel %conan_channel% ^
		-- -o runtime_shared=%option_runtime_shared% ^
	|| exit /B 1

	exit /B 0

:cleanup
	if exist %build_base_dir% (rmdir /Q /S %build_base_dir% || exit /B 1)
	exit /B 0