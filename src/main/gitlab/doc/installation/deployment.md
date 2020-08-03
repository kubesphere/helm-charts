---
stage: Enablement
group: Distribution
info: To determine the technical writer assigned to the Stage/Group associated with this page, see https://about.gitlab.com/handbook/engineering/ux/technical-writing/#designated-technical-writers
---

# Deployment Guide

Before running `helm install`, you need to make some decisions about how you will run GitLab.
Options can be specified using Helm's `--set option.name=value` command line option.
A complete list of command line options can be found [here](command-line-options.md).
This guide will cover required values and common options.

## Selecting configuration options

In each section collect the options that will be combined to use with `helm install`.

### Secrets

There are some secrets that need to be created (e.g. SSH keys). By default they will be generated automatically, but if you want to specify them, you can follow the [secrets guide](secrets.md).

### Networking and DNS

By default, the chart relies on Kubernetes `Service` objects of `type: LoadBalancer`
to expose GitLab services using name-based virtual servers configured with`Ingress`
objects. You'll need to specify a domain which will contain records to resolve
`gitlab`, `registry`, and `minio` (if enabled) to the appropriate IP for your chart.

*Include these options in your Helm install command:*

```shell
--set global.hosts.domain=example.com
```

#### Dynamic IPs with external-dns

If you plan to use an automatic DNS registration service like [external-dns](https://github.com/kubernetes-sigs/external-dns),
you won't need any additional configuration for GitLab, but you will need to deploy it to your cluster. If external-dns is your choice, the project page [has a comprehensive guide](https://github.com/kubernetes-sigs/external-dns#deploying-to-a-cluster) for each supported provider.

If you provisioned a GKE cluster using the scripts in this repo, [external-dns](https://github.com/kubernetes-sigs/external-dns)
is already installed in your cluster.

#### Static IP

If you plan to manually configure your DNS records they should all point to a
static IP. For example if you choose `example.com` and you have a static IP
of `10.10.10.10`, then `gitlab.example.com`, `registry.example.com` and
`minio.example.com` (if using MinIO) should all resolve to `10.10.10.10`.

If you are using GKE, there is some documentation [here](cloud/gke.md#creating-the-external-ip)
for configuring static IPs and DNS. Consult your Cloud and/or DNS provider's
documentation for more help on this process.

*Include these options in your Helm install command:*

```shell
--set global.hosts.externalIP=10.10.10.10
```

### Persistence

By default the chart will create Volume Claims with the expectation that a dynamic provisioner will create the underlying Persistent Volumes. If you would like to customize the storageClass or manually create and assign volumes, please review the [storage documentation](storage.md).

> **Important**: After initial installation, making changes to your storage settings requires manually editing Kubernetes
> objects, so it's best to plan ahead before installing your production instance of GitLab to avoid extra storage migration work.

### TLS certificates

You should be running GitLab using https which requires TLS certificates. By default the
chart will install and configure [cert-manager](https://github.com/jetstack/cert-manager)
to obtain free TLS certificates.
If you have your own wildcard certificate, you already have cert-manager installed, or you
have some other way of obtaining TLS certificates, [read about more TLS options here](tls.md).

For the default configuration, you must specify an email address to register your TLS
certificates.

*Include these options in your Helm install command:*

```shell
--set certmanager-issuer.email=me@example.com
```

### PostgreSQL

By default this chart provides an in-cluster PostgreSQL database, for trial
purposes only.

> **NOTE: This configuration is not recommended for use in production.**
>
> - A single StatefulSet is provided by [bitnami/PostgreSQL](https://hub.helm.sh/charts/bitnami/postgresql) by default.
> - As of 4.0.0 of these charts, replication is available internally, but _not enabled by default_. Such functionality has not been load tested by GitLab.

You can read more about setting up your production-ready database in the [advanced database docs](../advanced/external-db/index.md).

If you have an external PostgreSQL database ready, the chart can be configured to
use it as shown below.

*Include these options in your Helm install command:*

```shell
--set postgresql.install=false
--set global.psql.host=production.postgress.hostname.local
--set global.psql.password.secret=kubernetes_secret_name
--set global.psql.password.key=key_that_contains_postgres_password
```

### Redis

All Redis configuration settings have been moved and consolidated on the
[charts/globals.md](../charts/globals.md#configure-redis-settings) page.

> **NOTE: This configuration is not recommended for use in production.**
>
> - A single StatefulSet is provided by [bitnami/Redis](https://hub.helm.sh/charts/bitnami/redis) by default.
> - As of 4.0.0 of these charts, replication is available internally, but _not enabled by default_. Such functionality has not been load tested by GitLab.

You can read more about setting up a production-ready Redis instance in the [advanced Redis docs](../advanced/external-redis/index.md).

### MinIO

By default this chart provides an in-cluster MinIO deployment to provide an object storage API.

> **NOTE: This configuration is not recommended for use in production.**
>
> - A singleton, non-resilient Deployment is provided by our [MinIO fork](../charts/minio/index.md).

You can read more about setting up your production-ready object storage in the [external object storage](../advanced/external-object-storage/index.md)

### Prometheus

We use the [upstream Prometheus chart](https://github.com/helm/charts/tree/master/stable/prometheus#configuration),
and do not override values from our own defaults.
We do, however, default disable `alertmanager`, `nodeExporter`, and
`pushgateway`.

Refer to the [Prometheus chart documentation](https://github.com/helm/charts/tree/master/stable/prometheus#configuration) for the
exhaustive list of configuration options and ensure they are sub-keys to
`prometheus`, as we use this as requirement chart.

For instance, the requests for persistent storage can be controlled with:

```yaml
prometheus:
  alertmanager:
    enabled: false
    persistentVolume:
      enabled: false
      size: 2Gi
  pushgateway:
    enabled: false
    persistentVolume:
      enabled: false
      size: 2Gi
  server:
    persistentVolume:
      enabled: true
      size: 8Gi
```

### Outgoing email

By default outgoing email is disabled. To enable it, provide details for your SMTP server
using the `global.smtp` and `global.email` settings. You can find details for these settings in the
[command line options](command-line-options.md#outgoing-email-configuration).

If your SMTP server requires authentication make sure to read the section on providing
your password in the [secrets documentation](secrets.md#smtp-password).
You can disable authentication settings with `--set global.smtp.authentication=""`.

If your Kubernetes cluster is on GKE, be aware that SMTP [port 25
is blocked](https://cloud.google.com/compute/docs/tutorials/sending-mail/#using_standard_email_ports).

### Incoming email

By default incoming email is disabled. To enable it, provide details of your
IMAP server and access credentials using the `global.appConfig.incomingEmail`
settings. You can find details for these settings in the [command line options](command-line-options.md#incoming-email-configuration).
You will also have to create a Kubernetes secret containing IMAP password as
described in the [secrets guide](secrets.md#imap-password-for-incoming-emails).

To use reply-by-email feature, where users can reply to notification emails to
comment on issues and MRs, you need to configure both outgoing email and
incoming email settings.

### Service desk email

By default service desk email is disabled. To enable it, provide details of your
IMAP server and access credentials using the `global.appConfig.serviceDeskEmail`
settings. You can find details for these settings in the [command line options](command-line-options.md#service-desk-email-configuration).
You will also have to create a Kubernetes secret containing IMAP password as
described in the [secrets guide](secrets.md#imap-password-for-service-desk-emails).

NOTE: **Note** Service desk email _requires_ that [Incoming email](#incoming-email) be configured.

### Deploy the Community Edition

By default, the Helm charts use the Enterprise Edition of GitLab. If desired, you can instead use the Community Edition. Learn more about the [difference between the two](https://about.gitlab.com/install/ce-or-ee/).

*To deploy the Community Edition, include this option in your Helm install command:*

```shell
--set global.edition=ce
```

### RBAC

This chart defaults to creating and using RBAC. If your cluster does not have RBAC enabled, you will need to disable these settings:

```shell
--set certmanager.rbac.create=false
--set nginx-ingress.rbac.createRole=false
--set prometheus.rbac.create=false
--set gitlab-runner.rbac.create=false
```

### CPU and RAM Resource Requirements

The resource requests, and number of replicas for the GitLab components (not PostgreSQL, Redis, or MinIO) in this Chart
are set by default to be adequate for a small production deployment. This is intended to fit in a cluster with at least 8vCPU
and 30gb of RAM. If you are trying to deploy a non-production instance, you can reduce the defaults in order to fit into
a smaller cluster.

The [minimal GKE example values file](https://gitlab.com/gitlab-org/charts/gitlab/tree/master/examples/values-gke-minimum.yaml) provides an example of tuning the resources
to fit within a 3vCPU 12gb cluster.

The [minimal Minikube example values file](https://gitlab.com/gitlab-org/charts/gitlab/tree/master/examples/values-minikube-minimum.yaml) provides an example of tuning the
resources to fit within a 2vCPU, 4gb Minikube instance.

## Deploy using Helm

Once you have all of your configuration options collected, we can get any dependencies and
run Helm. In this example, we've named our Helm release `gitlab`.

```shell
helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab \
  --timeout 600s \
  --set global.hosts.domain=example.com \
  --set global.hosts.externalIP=10.10.10.10 \
  --set certmanager-issuer.email=me@example.com
```

NOTE: **Note**:
All Helm commands are specified using Helm v3 syntax. If the
Helm v2 syntax differs every effort is made to provide a note that details
the difference.

NOTE: **Note**:
If `helm install` is used there is a slight difference in the way
that Helm v2 and Helm v3 operate. When using Helm v2 if a release name
was not specified with the `--name` option it would randomly generate the
release name. Helm v3 requires that the release name be specified as a
positional argument on the command line unless the `--generate-name`
option is used.

NOTE: **Note**:
The timeout option above is handled differently between Helm v2
and Helm v3. With Helm v3 allows one to specify a duration with a unit
appended to the value (e.g. `120s` = `2m` and `210s` = `3m30s`). The
`--timeout` option is handled as the number of seconds _without_ the
unit specification.

NOTE: **Note**:
The use of the `--timeout` option is deceptive in that there are
multiple components that are deployed during an Helm install or upgrade
in which the `--timeout` is applied. The `--timeout` value is applied to
the installation of each component individually and not applied for the
installation of all the components. So intending to abort the Helm install
after 3 minutes by using `--timeout=3m` may result in the install completing
after 5 minutes because none of the installed components took longer than
3 minutes to install.

You can also use `--version <installation version>` option if you would like to install a specific version of GitLab.

Mappings between chart versions and GitLab versions can be found [here](../index.md#gitlab-version-mappings).

Instructions for installing a development branch rather than a tagged release can be found in the [developer deploy documentation](../development/deploy.md).

### GitLab Operator (experimental)

If you would like to use GitLab Operator to achieve zero downtime upgrades, please follow the [documentation for using the operator](operator.md).

## Monitoring the Deployment

This will output the list of resources installed once the deployment finishes which may take 5-10 minutes.

The status of the deployment can be checked by running `helm status gitlab` which can also be done while
the deployment is taking place if you run the command in another terminal.

## Initial login

You can access the GitLab instance by visiting the domain specified during
installation. If you manually created the secret for initial root password, you
can use that to sign in as `root` user. If not, GitLab would've automatically
created a random password for `root` user. This can be extracted by the
following command (replace `<name>` by name of the release - which is `gitlab`
if you used the command above).

```shell
kubectl get secret <name>-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 --decode ; echo
```
