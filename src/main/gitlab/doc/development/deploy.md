---
stage: Enablement
group: Distribution
info: To determine the technical writer assigned to the Stage/Group associated with this page, see https://about.gitlab.com/handbook/engineering/ux/technical-writing/#designated-technical-writers
---

# Deploy Development Branch

Clone the repository, and checkout the branch you want to deploy:

```shell
git clone git@gitlab.com:gitlab-org/charts/gitlab.git
git checkout <BRANCH_NAME>
```

> **Note:**
> You can test changes to external dependencies by modifying `requirements.yaml`
>
> It is possible to test external dependencies using a local repository. Use `file://PATH_TO_DEPENDENCY_REPO`
> where the path may be relative to the chartpath or absolute. For example, if using
> `/home/USER/charts/gitlab` as the main checkout and `/home/USER/charts/gitlab-runner`, the
> relative path would be `file://../gitlab-runner/` and the absolute path would be
> `file:///home/USER/charts/gitlab-runner/`. Pay close attention with absolute paths as it
> is very easy to miss the leading slash on the filepath.

Other steps from the [installation documentation](../installation/index.md) still apply. The difference is when deploying
a development branch, you need to add additional upstream repos and update the local dependencies, then pass the local
Git repo location to the Helm command.

From within your Git checkout of the repo, run the following Helm commands to install:

```shell
helm dependency update
helm upgrade --install gitlab . \
  --timeout 600s \
  --set global.imagePullPolicy=Always \
  --set global.hosts.domain=example.com \
  --set global.hosts.externalIP=10.10.10.10 \
  --set certmanager-issuer.email=me@example.com
```

NOTE: **Note**:
If using Helm v2, please see notes about the `--timeout` option
in the [Deployment documentation](../installation/deployment.md#deploy-using-helm).
