package builds

import github_enterprise.PullRequestsFeature
import jetbrains.buildServer.configs.kotlin.v2019_2.BuildType
import jetbrains.buildServer.configs.kotlin.v2019_2.DslContext
import jetbrains.buildServer.configs.kotlin.v2019_2.buildFeatures.commitStatusPublisher
import jetbrains.buildServer.configs.kotlin.v2019_2.triggers.vcs

object BuildChain : BuildType({
    id("xerces_build_chain")

    name = "Xerces Build Chain"
    allowExternalStatus = true
    type = Type.COMPOSITE
    buildNumberPattern = "%build.vcs.number%"

    vcs {
        root(DslContext.settingsRoot)
        showDependenciesChanges = true
    }

    triggers {
        vcs {}
    }

    this.features.feature(PullRequestsFeature.pullRequestsFeature)

    features {
        commitStatusPublisher {
            id = "githubEnterpriseCommitStatusPublisher"
            vcsRootExtId = "${DslContext.settingsRoot.id}"
            publisher = github {
                githubUrl = "https://github.hexagon.com/api/v3"
                authType = personalToken {
                    token = "credentialsJSON:de987814-09c1-4353-8131-207b9a34a6f9"
                }
            }
            param("github_oauth_user", "teamcity-hbg")
        }
    }
})

