# Nginx

## TL;DR;

```console
helm install ks-main/nginx
```

## Installing

To install the chart with the release name `my-release`:

```console
helm install --name my-release ks-main/nginx
```

The command deploys the nginx chart on the Kubernetes cluster in the default configuration. The configuration section lists the parameters that can be configured during installation.

## Uninstalling

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the nginx chart and their default values.

Parameter | Description | Default
--- | --- | ---
`image.html.repository` | The image holding static files to serve on Nginx, which locate in `/html` within the container; if specified, an initContainer will copy files under `/html` to `/usr/share/nginx/html` in Nginx container | none
`image.html.tag` | The tag of the image holding static files to serve on Nginx | none
`image.html.pullPolicy` | The pull policy of the image holding static files to serve on Nginx | none
`image.nginx.repository` | The image of Nginx container | `nginx`
`image.nginx.tag` | The tag of the Nginx image | `1.16.0-alpine`
`image.nginx.pullPolicy` | The pull policy of the Nginx image | `IfNotPresent`
`service.type` | The service type, can be `ClusterIP`, `NodePort` | `ClusterIP`
`service.port` | The service port within the pod container | `80`
`service.nodePort` | If `service.type` is `NodePort`, this value will be used | none
`extraVolumes` | Extra volumes | []
`extraMountVolumes` | Extra mount volumes | []
`extraInitContainers` | Extra init containers | []
`configurationFile` | Custom configuration file to override `/etc/nginx/nginx.conf` | none
`extraConfigurationFiles` | Custom configuration files to put under `/etc/nginx/conf.d` | none
