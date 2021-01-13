@echo off
setlocal

call buildsystem\settings.bat

call :install_project_utils latest ||  goto failure
call :install_cmake 3.18.3 ||  goto failure
call :install_conan 1.27.1 ||  goto failure
goto :eof

:prepare
	if not exist %local% (mkdir %local%) || exit /b 1
	exit /b 0

:install_project_utils
	set block_name=InstallProjectUtils
	echo ##teamcity[blockOpened name='%block_name%']
	setlocal
	set version=%~1
	call :prepare || exit /b 1
	if exist %local%\project-utils.exe (del %local%\project-utils.exe || exit /b 1)
	curl ^
		--ssl-no-revoke ^
		--fail ^
		--user leica-public:leica-public ^
		--output %local%\project-utils.zip ^
		--location %ARTIFACTORY_BASE_URL%/leica-generic/Tools/project-utils/%version%/project-utils-x86-windows.zip ^
	|| exit /b 1
	7z x -o%local% %local%\project-utils.zip || exit /b 1
	del %local%\project-utils.zip || exit /b 1
	%local%\project-utils.exe --version || exit /b 1
	echo ##teamcity[blockClosed name='%block_name%']
	exit /b 0

:install_cmake
	set block_name=InstallCMake
	echo ##teamcity[blockOpened name='%block_name%']
	setlocal
	set version=%~1
	call :prepare || exit /b 1
	if exist %local%\cmake (rmdir /s /q %local%\cmake || exit /b 1)
	curl ^
		--ssl-no-revoke ^
		--fail ^
		--user leica-public:leica-public ^
		--output %local%\cmake.zip ^
		--location %ARTIFACTORY_BASE_URL%/leica-generic/Tools/cmake/cmake-%version%-win64-x64.zip ^
	|| exit /b 1
	7z x -o%local% %local%\cmake.zip || exit /b 1
	del %local%\cmake.zip || exit /b 1
	rename %local%\cmake-%version%-win64-x64 cmake || exit /b 1
	%local%\cmake\bin\cmake.exe --version || exit /b 1
	echo ##teamcity[blockClosed name='%block_name%']
	exit /b 0

:install_conan
	set block_name=InstallConan
	echo ##teamcity[blockOpened name='%block_name%']
	setlocal
	set version=%~1
	call :prepare || exit /b 1
	if exist %local%\conan (rmdir /s /q %local%\conan || exit /b 1)
	if exist %CONAN_USER_HOME%\.conan (rmdir /s /q %CONAN_USER_HOME%\.conan || exit /b 1)
	curl ^
		--ssl-no-revoke ^
		--fail ^
		--user leica-public:leica-public ^
		--output %local%\conan.zip ^
		--location %ARTIFACTORY_BASE_URL%/leica-generic/Tools/conan/conan-win-64_%version:.=_%.zip ^
	|| exit /b 1
	7z x -o%local% %local%\conan.zip || exit /b 1
	del %local%\conan.zip || exit /b 1
	%local%\conan\conan.exe --version || exit /b 1
	echo ##teamcity[blockClosed name='%block_name%']
	exit /b 0

:failure
	echo ##teamcity[message text='Exiting with failure' status='ERROR']
	echo ##teamcity[blockClosed name='%block_name%']
	exit /b 1