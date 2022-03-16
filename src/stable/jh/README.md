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