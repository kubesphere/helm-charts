[![pipeline status](https://jihulab.com/gitlab-cn/charts/gitlab/badges/main-jh/pipeline.svg)](https://jihulab.com/gitlab-cn/charts/gitlab/pipelines)

# Cloud Native JiHu GitLab Helm Chart

The `gitlab-jh` chart is the best way to operate JiHu GitLab on Kubernetes. It contains
all the required components to get started, and can scale to large deployments.

Some of the key benefits of this chart and [corresponding containers](https://jihulab.com/gitlab-cn/build/cng-images) are:

- Improved scalability and reliability.
- No requirement for root privileges.
- Utilization of object storage instead of NFS for storage.

## Detailed documentation

See the [repository documentation](jh/doc/index.md) for how to install JiHu GitLab and
other information on charts, tools, and advanced configuration.

For easy of reading, you can find this documentation rendered on
[docs.gitlab.cn/charts](https://docs.gitlab.cn/charts).

### Configuration Properties

We're often asked to put a table of all possible properties directly into this README.
These charts are _massive_ in scale, and as such the number of properties exceeds
the amount of context we're comfortable placing here. Please see our (nearly)
[comprehensive list of properties and defaults](jh/doc/installation/command-line-options.md).

**Note:** We _strongly recommend_ following our complete documentation, as opposed to
jumping directly into the settings list.

### Installation

#### Pre-requirement

* A Kubernetes cluster, version is higher than v1.16
* `kubectl` version is higher than v1.16
* Helm V3, version is higher than 3.3.1

#### Add JH helm chart repo

Running the below command to add the JH helm charts repo

```
$ helm repo add jh https://charts.gitlab.cn/
```

#### Install the JH 

Running the below command to install the JH release using JH helm charts

```
$ helm install jh jh/gitlab --namespace jh --version 5.7.0 --set global.hosts.domain=jh.example.com,certmanager-issuer.email=your-email@address
```

Parameters specification:

* ` global.hosts.domain`: set the JH instance domain, once the instance is up, can login the instance using this domain;
* `certmanager-issuer.email`: set the email address used by certmanager


Checking the instance state:

```
kubectl -n jh get pods
NAME                                               READY   STATUS      RESTARTS   AGE
jh-certmanager-65f6db7b98-cs28b                    1/1     Running     0          2m34s
jh-certmanager-cainjector-7547dc9f6c-mktb6         1/1     Running     0          2m34s
jh-certmanager-webhook-f5f7cb774-n4m5f             1/1     Running     0          2m34s
jh-gitaly-0                                        1/1     Running     0          2m31s
jh-gitlab-exporter-578fcbd446-vc2sv                1/1     Running     0          2m34s
jh-gitlab-shell-79656578b-4xcfg                    1/1     Running     0          2m34s
jh-gitlab-shell-79656578b-m8zg7                    1/1     Running     0          2m16s
jh-issuer-1-svljr                                  0/1     Completed   0          2m31s
jh-migrations-1-4nm4m                              0/1     Completed   0          2m30s
jh-minio-7749cb9b5f-6mvgq                          1/1     Running     0          2m33s
jh-minio-create-buckets-1-cvzgk                    0/1     Completed   0          2m30s
jh-nginx-ingress-controller-7c755cdd7f-kgmg4       1/1     Running     0          2m33s
jh-nginx-ingress-controller-7c755cdd7f-zvh8t       1/1     Running     0          2m33s
jh-nginx-ingress-defaultbackend-7c9dc8695b-w6mfj   1/1     Running     0          2m33s
jh-postgresql-0                                    2/2     Running     0          2m31s
jh-redis-master-0                                  2/2     Running     0          2m31s
jh-registry-69687b758b-2c5z4                       1/1     Running     0          2m32s
jh-registry-69687b758b-gvt6f                       1/1     Running     0          2m16s
jh-sidekiq-all-in-1-v2-58ff448759-gpp62            1/1     Running     0          2m34s
jh-toolbox-78b4b78498-qtlnv                        1/1     Running     0          2m33s
jh-webservice-default-6db8bc57d9-cdpmh             2/2     Running     0          2m33s
jh-webservice-default-6db8bc57d9-flh2k             2/2     Running     0          2m16s

$ kubectl -n jh get ing
NAME                    CLASS      HOSTS                  ADDRESS           PORTS     AGE
jh-minio                jh-nginx   minio.jh.example.com      124.156.122.184   80, 443   2m51s
jh-registry             jh-nginx   registry.jh.example.com   124.156.122.184   80, 443   2m51s
jh-webservice-default   jh-nginx   gitlab.jh.example.com     124.156.122.184   80, 443   2m51s
```

Finally, you can login the JH instance using `https://gitlab.jh.example.com`.

## Architecture and goals

See [architecture documentation](jh/doc/architecture/index.md) for an overview
of this project goals and architecture.

<!--
## Known issues and limitations

See [limitations](jh/doc/index.md#limitations).

## Release Notes

Check the [releases documentation](jh/doc/releases/index.md) for information on important releases,
and see the [changelog](CHANGELOG.md) for the full details on any release.

## Contributing

See the [contribution guidelines](CONTRIBUTING.md) and then check out the
[development styleguide](doc/development/index.md).
-->


