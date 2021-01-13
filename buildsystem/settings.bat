pushd %~dp0

set ARTIFACTORY_REPOSITORY=leica-internal
set local=%CD%\local

if NOT DEFINED ARTIFACTORY_BSE_URL (
	set ARTIFACTORY_BASE_URL=https://artifactory-hbg.leica-geosystems.com/artifactory
)
if NOT DEFINED CONAN_USER_HOME (
	set CONAN_USER_HOME=%local%\_conan
)

set project_utils_bin=%local%\project-utils.exe
set cmake_bin=%local%\cmake\bin\cmake.exe
set conan_bin=%local%\conan\conan.exe

popd