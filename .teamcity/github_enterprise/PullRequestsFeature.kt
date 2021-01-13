package github_enterprise

import jetbrains.buildServer.configs.kotlin.v2019_2.DslContext
import jetbrains.buildServer.configs.kotlin.v2019_2.buildFeatures.PullRequests

class PullRequestsFeature {
    companion object {
        val pullRequestsFeature = PullRequests {
            id = "pullRequestFeature"
            vcsRootExtId = "${DslContext.settingsRoot.id}"
            provider = github {
                authType = token {
                    token = "credentialsJSON:de987814-09c1-4353-8131-207b9a34a6f9"
                }
                filterAuthorRole = PullRequests.GitHubRoleFilter.MEMBER
            }
        }
    }
}
