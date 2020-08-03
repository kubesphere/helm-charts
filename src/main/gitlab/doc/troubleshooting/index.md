---
stage: Enablement
group: Distribution
info: To determine the technical writer assigned to the Stage/Group associated with this page, see https://about.gitlab.com/handbook/engineering/ux/technical-writing/#designated-technical-writers
---

# Troubleshooting

## UPGRADE FAILED: "$name" has no deployed releases

This error will occur on your second install/upgrade if your initial
install failed.

If your initial install completely failed, and GitLab was never operational, you
should first purge the failed install before installing again.

```shell
helm uninstall <release-name>
```

NOTE: **Note**:
With Helm v2, the uninstall command would be `helm delete --purge <release-name>`.

If instead, the initial install command timed out, but GitLab still came up successfully,
you can add the `--force` flag to the `helm upgrade` command to ignore the error
and attempt to update the release.

Otherwise, if you received this error after having previously had successful deploys
of the GitLab chart, then you are encountering a bug. Please open an issue on our
[issue tracker](https://gitlab.com/gitlab-org/charts/gitlab/-/issues), and also check out
[issue #630](https://gitlab.com/gitlab-org/charts/gitlab/-/issues/630) where we recovered our
CI server from this problem.

## Error: this command needs 2 arguments: release name, chart path

An error like this could occur when you run `helm upgrade`
and there are some spaces in the parameters. In the following
example, `Test Username` is the culprit:

```shell
helm upgrade gitlab gitlab/gitlab --timeout 600s --set global.email.display_name=Test Username ...
```

NOTE: **Note**:
If using Helm v2, please see notes about the `--timeout` option
in the [Deployment documentation](../installation/deployment.md#deploy-using-helm).

To fix it, pass the parameters in single quotes:

```shell
helm upgrade gitlab gitlab/gitlab --timeout 600s --set global.email.display_name='Test Username' ...
```

## Application containers constantly initializing

If you experience Sidekiq, Webservice, or other Rails based containers in a constant
state of Initializing, you're likely waiting on the `dependencies` container to
pass.

If you check the logs of a given Pod specifically for the `dependencies` container,
you may see the following repeated:

```plaintext
Checking database connection and schema version
WARNING: This version of GitLab depends on gitlab-shell 8.7.1, ...
Database Schema
Current version: 0
Codebase version: 20190301182457
```

This is an indication that the `migrations` Job has not yet completed. The purpose
of this Job is to both ensure that the database is seeded, as well as all
relevant migrations are in place. The application containers are attempting to
wait for the database to be at or above their expected database version. This is
to ensure that the application does not malfunction to the schema not matching
expectations of the codebase.

1. Find the `migrations` Job. `kubectl get job -lapp=migrations`
1. Find the Pod being run by the Job. `kubectl get pod -ljob-name=<job-name>`
1. Examine the output, checking the `STATUS` column.

If the `STATUS` is `Running`, continue. If the `STATUS` is `Completed`, the application containers should start shortly after the next check passes.

Examine the logs from this pod. `kubectl logs <pod-name>`

Any failures during the run of this job should be addressed. These will block
the use of the application until resolved. Possible problems are:

- Unreachable or failed authentication to the configured PostgreSQL database
- Unreachable or failed authentication to the configured Redis services
- Failure to reach a Gitaly instance

## Applying configuration changes

The following command will perform the neccessary operations to apply any updates made to `gitlab.yaml`:

```shell
helm upgrade <release name> <chart path> -f gitlab.yaml
```

## Included GitLab Runner failing to register

This can happen when the runner registration token has been changed in GitLab. (This often happens after you have restored a backup)

1. Find the new shared runner token located on the `admin/runners` webpage of your GitLab installation.
1. Find the name of existing runner token Secret stored in Kubernetes

   ```shell
   kubectl get secrets | grep gitlab-runner-secret
   ```

1. Delete the existing secret

   ```shell
   kubectl delete secret <runner-secret-name>
   ```

1. Create the new secret with two keys, (`runner-regisration-token` with your shared token, and an empty `runner-token`)

   ```shell
   kubectl create secret generic <runner-secret-name> --from-literal=runner-registration-token=<new-shared-runner-token> --from-literal=runner-token=""
   ```

## Too many redirects

This can happen when you have TLS termination before the NGINX Ingress, and the tls-secrets are specified in the configuration.

1. Update your values to set `global.ingress.annotations."nginx.ingress.kubernetes.io/ssl-redirect": "false"`

   Via a values file:

   ```yaml
   # values.yml
   global:
     ingress:
       annotations:
         "nginx.ingress.kubernetes.io/ssl-redirect": "false"
   ```

   Via the Helm CLI:

   ```shell
   helm ... --set-string global.ingress.annotations."nginx.ingress.kubernetes.io/ssl-redirect"=false
   ```

1. Apply the change

>>>
**NOTE:**
When using an external service for SSL termination, that service is responsible for redirecting to https (if so desired).
>>>

## Upgrades fail with Immutable Field Error

### spec.clusterIP

Prior to the 3.0.0 release of these charts, the `spec.clusterIP` property
[had been populated into several Services](https://gitlab.com/gitlab-org/charts/gitlab/-/issues/1710)
despite having no actual value (`""`). This was a bug, and causes problems with Helm 3's three-way
merge of properties.

Once the chart was deployed with Helm 3, there would be _no possible upgrade path_ unless one
collected the `clusterIP` properties from the various Services and populated those into the values
provided to Helm, or the affected services are removed from Kubernetes.

The [3.0.0 release of this chart corrected this error](https://gitlab.com/gitlab-org/charts/gitlab/-/issues/1710), but it requires manual correction.

This can be solved by simply removing all of the affected services.

1. Remove all affected services:

   ```shell
   kubectl delete services -lrelease=RELEASE_NAME
   ```

1. Perform an upgrade via Helm.
1. Future upgrades will not face this error.

NOTE: **Note:** This will change any dynamic value for the `LoadBalancer` for NGINX Ingress from this chart, if in use. See [global Ingress settings documentation](../charts/globals.md#configure-ingress-settings) for more details regarding `externalIP`. You may be required to update DNS records!

### spec.selector

Sidekiq pods did not receive a unique selector prior to chart release
`3.0.0`. [The problems with this were documented in](https://gitlab.com/gitlab-org/charts/gitlab/-/issues/663).

Upgrades to `3.0.0` using Helm will automatically delete the old Sidekiq deployments and create new ones by appending `-v1` to the
name of the Sidekiq `Deployments`,`HPAs`, and `Pods`.

If you continue to run into this error on the Sidekiq deployment when installing `3.0.0`, resolve these with the following
steps:

1. Remove Sidekiq services

   ```shell
   kubectl delete deployment --cascade -lrelease=RELEASE_NAME,app=sidekiq
   ```

1. Perform an upgrade via Helm.

## `ImagePullBackOff`, `Failed to pull image` and `manifest unknown` errors

If you are using [`global.gitlabVersion`](../charts/globals.md#gitlab-version),
start by removing that property.
Check the [version mappings between the chart and GitLab](../index.md#gitlab-version-mappings)
and specify a compatible version of the `gitlab/gitlab` chart in your `helm` command.
