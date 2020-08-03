---
stage: Enablement
group: Distribution
info: To determine the technical writer assigned to the Stage/Group associated with this page, see https://about.gitlab.com/handbook/engineering/ux/technical-writing/#designated-technical-writers
---

# Migrating from Helm v2 to Helm v3

Users that are currently deploying the GitLab chart with Helm v2 should
not use the [Helm 2to3 plugin](https://github.com/helm/helm-2to3) at this time. [Issue #1982](https://gitlab.com/gitlab-org/charts/gitlab/-/issues/1982) has been raised
that may leave the deployed chart in a state that does not allow Helm v3
to upgrade the deployment after using the 2to3 plugin.

While this issue is being investigated the GitLab chart should continue
to be upgraded with Helm v2 until a fix is found. Please track the issue
for more information concerning the investigation and when a fix becomes
available.
