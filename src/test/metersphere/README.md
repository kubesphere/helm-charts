# MeterSphere Helm Chart

## How to install online

```bash
# for China users: helm repo add test https://charts.kubesphere.com.cn/test
helm repo add test https://charts.kubesphere.io/test
helm install metersphere -n metersphere test/metersphere
```

## How to install locally

- download dependency

```bash
helm dependency update
```

- install metersphere

```bash
helm install metersphere -n metersphere -f values.yaml .
```
