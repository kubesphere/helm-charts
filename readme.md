# Helm Charts for KubeSphere

## How to install these charts

Find the repository you want to use under `src/` directory and enter below command:

```shell
helm repo add main https://charts.kubesphere.io/main
```

## How to contribute

### To an existing Helm repo

Just place your charts under the repo, e.g. 

```shell
src/
├── main/
│   └── example-chart/
│       ├── Chart.yaml
│       ├── values.yaml
│       ├── templates/
│       └── ...
```

### To a new Helm repo

Just create a directory under `src/` for the new repo, and place your charts under it, e.g.

```shell
src/
├── main/
│   └── ...
├── example-repo/
│   └── example-chart/
│       ├── Chart.yaml
│       ├── values.yaml
│       ├── templates/
│       └── ...
```

