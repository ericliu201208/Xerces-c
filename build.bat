@echo off
setlocal

set SCRIPTDIR=%~dp0
set SCRIPTDIR=%SCRIPTDIR:~0,-1%

set target=%1
set runtime_linkage=%2
set BUILDSYSTEMDIR=%SCRIPTDIR%\buildsystem
call %BUILDSYSTEMDIR%\settings.bat

:: Leica version must correspond to the VERSION attribute in CMakeLists.txt
set conan_ref=XercesC/3.2.3+v1.0.0@leica/stable

set block_name=Build
echo ##teamcity[blockOpened name='%block_name%']
call %BUILDSYSTEMDIR%\tool.bat build %target% %runtime_linkage% %SCRIPTDIR% || goto failure
echo ##teamcity[blockClosed name='%block_name%']

set block_name=ConanPackageExport
echo ##teamcity[blockOpened name='%block_name%']
%conan_bin% remove --force %conan_ref%
%conan_bin% search %conan_ref%
call %BUILDSYSTEMDIR%\tool.bat export %target% %runtime_linkage% %SCRIPTDIR% || goto failure
%conan_bin% search %conan_ref% || goto failure
echo ##teamcity[blockClosed name='%block_name%']

set block_name=TestConanPackage
echo ##teamcity[blockOpened name='%block_name%']
::call tests\test.bat %target% %runtime_linkage% || goto failure
echo ##teamcity[blockClosed name='%block_name%']


if "%BUILD_IS_PERSONAL%" == "true" (
	echo Don't upload. This build is a personal build!
	exit /B 0
)

set block_name=ConanPackageUpload
echo ##teamcity[blockOpened name='%block_name%']
if "%ARTIFACTORY_UPLOAD%" == "true" (
	%conan_bin% remote add %ARTIFACTORY_REPOSITORY% %ARTIFACTORY_BASE_URL%/api/conan/conan-leica True --force ^
	|| goto failure_upload
	%conan_bin% upload -r %ARTIFACTORY_REPOSITORY% --force --all --check %conan_ref% ^
	|| goto failure_upload
) else (
	echo INFO: Upload to Artifactory: DISABLED
)
echo ##teamcity[blockClosed name='%block_name%']
goto :eof

:failure
	echo ##teamcity[publishArtifacts 'build/**/BuildLog.htm =^> logs']
	echo ##teamcity[message text='Exiting with failure' status='ERROR']
	echo ##teamcity[blockClosed name='%block_name%']
	exit /B 1