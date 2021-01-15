package builds

import github_enterprise.PullRequestsFeature
import jetbrains.buildServer.configs.kotlin.v2019_2.BuildType
import jetbrains.buildServer.configs.kotlin.v2019_2.DslContext
import jetbrains.buildServer.configs.kotlin.v2019_2.ParameterDisplay

open class BaseBuildType(target: String) : BuildType() {
    init {
        // IDs can contain only alphanumeric characters and underscores
        id("xerces${target.replace("-", "_")}")
        name = "xerces-${target}"
        buildNumberPattern = "%build.vcs.number%"
        enablePersonalBuilds = false

        failureConditions {
            executionTimeoutMin = 120
        }

        vcs {
            root(DslContext.settingsRoot)
            cleanCheckout = true
        }

        params {
            checkbox("env.ARTIFACTORY_UPLOAD", "false", checked = "true", unchecked = "false")
        }

        this.features.feature(PullRequestsFeature.pullRequestsFeature)
    }
}

