import builds.*
import jetbrains.buildServer.configs.kotlin.v2019_2.Project
import jetbrains.buildServer.configs.kotlin.v2019_2.sequential

object Project : Project({

    val allBuilds = sequential {
        parallel {
	        buildType(WindowsBuildType("x86-windows-vs2008"))	
            buildType(WindowsBuildType("armv7-windowsec7-vs2008"))
        }
        buildType(BuildChain)
    }

    // Register Build Types in the Project
    allBuilds.buildTypes().forEach { buildType(it) }
    // Disable editing of project and build settings from the UI to avoid issues with TeamCity
    params {
        param("teamcity.ui.settings.readOnly", "true")
    }	
})

