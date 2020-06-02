# Test Charts

This Helm repository is expected to be only used for experimental/verification purpose.

## Install

```shell
helm repo add test https://charts.kubesphere.io/test
```

## Contribute

Place your charts under this directory, one chart per separate directory, e.g.

```shell
src/
├── test/
│   ├── example-chart/
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   ├── templates/
│   │   └── ...
│   └── example-chart-2/
│       ├── Chart.yaml
│       ├── values.yaml
│       ├── templates/
│       └── ...
```
