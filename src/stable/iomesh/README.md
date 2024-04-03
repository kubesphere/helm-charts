# IOMesh Helm Chart

## Introduction

IOMesh is a Kubernetes-native storage system that manages storage resources within a Kubernetes cluster, automates operations and maintenance, and provides persistent storage, data protection and migration capabilities for data applications such as MySQL, Cassandra, MongoDB and middleware running on Kubernetes.

**Homepage:** [https://docs.iomesh.com/introduction/introduction](https://docs.iomesh.com/introduction/introduction)

## Prerequisites

[https://docs.iomesh.com/deploy-iomesh-cluster/prerequisites](https://docs.iomesh.com/deploy-iomesh-cluster/prerequisites)

## Installation

[https://docs.iomesh.com/deploy-iomesh-cluster/install-iomesh](https://docs.iomesh.com/deploy-iomesh-cluster/install-iomesh)

## Uninstallation

Uninstall **IOMesh cluster** helm chart

Specify the current release name and namespace to uninstall.

```bash
helm uninstall --namespace iomesh-system iomesh
```
If there are IOMesh resources left after uninstalling IOMesh due to network or other issues, run the following command to clear all IOMesh resources.
```bash
curl -sSL https://iomesh.run/uninstall_iomesh.sh | sh -
```
## Configuration

[https://docs.iomesh.com/deploy-iomesh-cluster/setup-iomesh](https://docs.iomesh.com/deploy-iomesh-cluster/setup-iomesh)

## Contact Us

[https://www.iomesh.com/contact](https://www.iomesh.com/contact)
