#storageclass-accessor helm-charts

## How to use 
You need to add this repository to your Helm repositories:
```shell
helm repo add main https://charts.kubesphere.io/main
```

## Quick start 

### Installing the Chart

To install the chart with the release name `storageclass-accessor` using a dedicated namespace(recommended):

```shell
helm install --create-namespace --namespace storageclass-accessor storageclass-accessor main/storageclass-accessor
```

### Uninstalling

To uninstall/delete the `stoargeclass-accessor` deployment:

```shell
helm delete storageclass-accessor --namespace storageclass-accessor
```

## Configuration

The following table lists the configurable parameters of the chart and their default values.

Parameter | Description | Default
--- | --- | ---
`image.repository` | Image repository of accessor deployment | `kubesphere/storageclass-accessor`
`webhook.timeoutSeconds` | The maximum number of seconds used by the webhook to verify | `5`