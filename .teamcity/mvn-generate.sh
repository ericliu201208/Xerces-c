#!/usr/bin/env bash
set -e

# This script calls maven to "compile" the Kotlin/DSL into XML files.
# It's basically the same thing as TeamCity does.
#
# This is a convenience script to check for syntax errors locally.


SCRIPT_DIR=$(dirname $(readlink -f $0))

cd ${SCRIPT_DIR}
mvn org.jetbrains.teamcity:teamcity-configs-maven-plugin:generate

