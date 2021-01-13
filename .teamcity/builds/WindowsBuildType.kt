package builds

import jetbrains.buildServer.configs.kotlin.v2019_2.buildSteps.script

class WindowsBuildType(target: String) : BaseBuildType(target) {
    init {
        steps {
            script {
                name = "Prepare build tools"
                scriptContent = "teamcity-setup-agent.bat"
            }
        }

        steps {
            script {
                name = "Build Library for $target with shared runtime"
                scriptContent = "build.bat $target shared"
            }
        }

        steps {
            script {
                name = "Build Library for $target with static runtime"
                scriptContent = "build.bat $target static"
            }
        }

        requirements {
            // Extract Visual Studio version, i.e. x86_64-windows-vs2015 -> VS2015
            exists(target.split("-").last().toUpperCase())
            doesNotExist("LEGACY_AGENT") // Prevents scheduling on an old agent
        }
    }
}
