# Ks-installer

## Installing

To install the chart with the release name `my-release`:

```console
helm install --name my-release experimental/ks-installer
```

The command deploys the kubesphere installer chart on the Kubernetes cluster in the default configuration. 

## Uninstalling

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Ks-installer Configuration

The following table lists the configurable parameters of the ks-installer chart and their default values.

Parameter | Description | Default
--- | --- | ---
`image.repository` | The image of ks-installer container | `kubesphere/ks-installer`
`image.tag` | The tag of the ks-installer image | `v2.1.1`
`image.pullPolicy` | The pull policy of the ks-installer image | `Always`

## KubeSphere Configuration

You can set the configuration of kubespher in `values.yaml`

Parameter | Description | Default
--- | --- | ---
<table border=0 cellpadding=0 cellspacing=0 width=1288 style='border-collapse:
 collapse;table-layout:fixed;width:966pt'>
 <col width=202 style='mso-width-source:userset;mso-width-alt:7196;width:152pt'>
 <col width=232 style='mso-width-source:userset;mso-width-alt:8248;width:174pt'>
 <col width=595 style='mso-width-source:userset;mso-width-alt:21162;width:446pt'>
 <col class=xl6519753 width=259 style='mso-width-source:userset;mso-width-alt:
 9216;width:194pt'>
 <tr height=18 style='height:13.8pt'>
  <td colspan=2 height=18 class=xl6619753 width=434 style='height:13.8pt;
  width:326pt'>Parameter</td>
  <td class=xl6619753 width=595 style='width:446pt'>Description</td>
  <td class=xl6819753 width=259 style='width:194pt'>Default</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>persistence</td>
  <td class=xl6719753>storageClass</td>
  <td class=xl1519753>Installer will use the default StorageClass, you can also designate another StorageClass</td>
  <td class=xl6519753>“”</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td rowspan=4 height=84 class=xl6719753 style='height:62.4pt'>etcd</td>
  <td class=xl6719753>monitoring</td>
  <td class=xl1519753>Whether to enable etcd monitoring</td>
  <td class=xl6519753>False</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>endpointIps</td>
  <td class=xl1519753>etcd address（for etcd cluster, see an example value like `192.168.0.7,192.168.0.8,192.168.0.9`）</td>
  <td class=xl6519753></td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>port</td>
  <td class=xl1519753>etcd port (Default port: 2379, you can appoint any other port)</td>
  <td class=xl6519753>2379</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>tlsEnable</td>
  <td class=xl1519753>Whether to enable etcd TLS certificate authentication.（True / False）</td>
  <td class=xl6519753>True</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td rowspan=5 height=105 class=xl6719753 style='height:78.0pt'>common</td>
  <td class=xl6719753>mysqlVolumeSize</td>
  <td class=xl1519753>MySQL volume size (cannot be modified after set)</td>
  <td class=xl6519753>20Gi</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>minioVolumeSize</td>
  <td class=xl1519753>Minio volume size (cannot be modified after set)</td>
  <td class=xl6519753>20Gi</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>etcdVolumeSize</td>
  <td class=xl1519753>etcd volume size (cannot be modified after set)</td>
  <td class=xl6519753>20Gi</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>openldapVolumeSize</td>
  <td class=xl1519753>openldap volume size (cannot be modified after set)</td>
  <td class=xl6519753>2Gi</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>redisVolumSize</td>
  <td class=xl1519753>redis volume size (cannot be modified after set)</td>
  <td class=xl6519753>2Gi</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td rowspan=2 height=42 class=xl6719753 style='height:31.2pt'>console</td>
  <td class=xl6719753>enableMultiLogin</td>
  <td class=xl1519753>Whether to enable multiple point login of one account（True / False）</td>
  <td class=xl6519753>False</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>port</td>
  <td class=xl1519753>Console Port（NodePort）</td>
  <td class=xl6519753>30880</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td rowspan=4 height=84 class=xl6719753 style='height:62.4pt'>monitoring</td>
  <td class=xl6719753>prometheusReplicas</td>
  <td class=xl1519753>Prometheus replicas</td>
  <td class=xl6519753>1</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>prometheusMemoryRequest</td>
  <td class=xl1519753>Prometheus memory request </td>
  <td class=xl6519753>400Mi</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>prometheusVolumeSize</td>
  <td class=xl1519753>Prometheus volume size</td>
  <td class=xl6519753>20Gi</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>grafana.enabled</td>
  <td class=xl1519753>Whether to enable Grafana installation（True / False）</td>
  <td class=xl6519753>False</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>openpitrix </br>(at least 0.3 core, 300 MiB)</td>
  <td class=xl6719753>enable</td>
  <td class=xl1519753>App store and app templates are based on OpenPitrix, it's recommended to enable OpenPitrix installation（True / False）</td>
  <td class=xl6519753>False</td>
 <tr height=21 style='height:15.6pt'>
  <td rowspan=9 height=189 class=xl6619753 style='height:140.4pt'>logging</br>(at least 56 M, 2.76 G)</td>
  <td class=xl6719753>enabled</td>
  <td class=xl1519753>Whether to enable logging system installation<span
  style='mso-spacerun:yes'>&nbsp;&nbsp; </span>（True / False）</td>
  <td class=xl6519753>False</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>elasticsearchMasterReplicas</td>
  <td class=xl1519753>Elasticsearch master replicas</td>
  <td class=xl6519753>1</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>elasticsearchDataReplicas</td>
  <td class=xl1519753>Elasticsearch data replicas</td>
  <td class=xl6519753>1</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>logsidecarReplicas</td>
  <td class=xl1519753>Logsidecar replicas</td>
  <td class=xl6519753>2</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>elasticsearchVolumeSize</td>
  <td class=xl1519753>ElasticSearch volume size</td>
  <td class=xl6519753>20Gi</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>logMaxAge</td>
  <td class=xl1519753>How many days the logs are remained </td>
  <td class=xl6519753>7</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>elkPrefix</td>
  <td class=xl1519753>Log index<span style='mso-spacerun:yes'>&nbsp;</span></td>
  <td class=xl6519753>logstash<span style='mso-spacerun:yes'>&nbsp;</span></td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>containersLogMountedPath</td>
  <td class=xl1519753>The mounting path of container logs</td>
  <td class=xl6519753>“”</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>kibana.enabled</td>
  <td class=xl1519753>Whether to enable Kibana installation<span style='mso-spacerun:yes'>&nbsp;
  </span>（True / False）</td>
  <td class=xl6519753>False</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td rowspan=8 height=168 class=xl6619753 style='height:124.8pt'>devops </br>(at least 0.47 core, 8.6  G for multi-node cluster)</td>
  <td class=xl6719753>enabled</td>
  <td class=xl1519753>Whether to enable DevOps system installation<span style='mso-spacerun:yes'>&nbsp;
  </span>（True / False）</td>
  <td class=xl6519753>False</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>jenkinsMemoryLim</td>
  <td class=xl1519753>Jenkins Memory Limit</td>
  <td class=xl6519753>2Gi</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>jenkinsMemoryReq</td>
  <td class=xl1519753>Jenkins Memory Request</td>
  <td class=xl6519753>1500Mi</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>jenkinsVolumeSize</td>
  <td class=xl1519753>Jenkins volume size</td>
  <td class=xl6519753>8Gi</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>jenkinsJavaOpts_Xms</td>
  <td class=xl1519753>Jenkins JVM parameter<span style='mso-spacerun:yes'>&nbsp;
  </span>（Xms）</td>
  <td class=xl6519753>512m</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>jenkinsJavaOpts_Xmx</td>
  <td class=xl1519753>Jenkins<span style='mso-spacerun:yes'>&nbsp;
  </span>JVM parameter（Xmx）</td>
  <td class=xl6519753>512m</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>jenkinsJavaOpts_MaxRAM</td>
  <td class=xl1519753>Jenkins<span style='mso-spacerun:yes'>&nbsp;
  </span>JVM parameter（MaxRAM）</td>
  <td class=xl6519753>2Gi</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>sonarqube.enabled</td>
  <td class=xl1519753>Whether to install SonarQube（True / False）</td>
  <td class=xl6519753>False</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>metrics-server </br>(at least 5 m, 44.35 MiB)</td>
  <td class=xl6719753>enabled</td>
  <td class=xl1519753>Whether to install metrics_server<span
  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp; </span>（True / False）</td>
  <td class=xl6519753>False</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6619753 style='height:15.6pt'>servicemesh</br>(at least 2 core, 3.6 G)</td>
  <td class=xl6719753>enabled</td>
  <td class=xl1519753>Whether to install Istio<span style='mso-spacerun:yes'>&nbsp;
  </span>（True / False）</td>
  <td class=xl6519753>False</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6619753 style='height:15.6pt'>notification </br>(Notification and Alerting together, at least 0.08 core, 80 M)</td>
  <td class=xl6719753>enabled</td>
  <td class=xl1519753>Whether to install Notification sysytem （True / False）</td>
  <td class=xl6519753>False</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6619753 style='height:15.6pt'>alerting</td>
  <td class=xl6719753>enabled</td>
  <td class=xl1519753>Whether to install Alerting sysytem （True / False）</td>
  <td class=xl6519753>False</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td rowspan=2 height=42 class=xl6619753 style='height:31.2pt'>harbor</br>(Harbor and Gitlab together, at least 0.58 core, 3.57 G)</td>
  <td class=xl6719753>enabled</td>
  <td class=xl1519753>Whether to install Harbor Registry<span style='mso-spacerun:yes'>&nbsp;
  </span>（True / False）</td>
  <td class=xl6519753>False</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>domain</td>
  <td class=xl1519753>Harbor domain name</td>
  <td class=xl6519753>harbor.devops.kubesphere.local</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td rowspan=2 height=42 class=xl6619753 style='height:31.2pt'>gitlab</td>
  <td class=xl6719753>enabled</td>
  <td class=xl1519753>Whether to install GitLab（True / False）</td>
  <td class=xl6519753>False</td>
 </tr>
 <tr height=21 style='height:15.6pt'>
  <td height=21 class=xl6719753 style='height:15.6pt'>domain</td>
  <td class=xl1519753>GitLab domain name</td>
  <td class=xl6519753>devops.kubesphere.local</td>
 </tr>
 <![if supportMisalignedColumns]>
 <tr height=0 style='display:none'>
  <td width=202 style='width:152pt'></td>
  <td width=232 style='width:174pt'></td>
  <td width=595 style='width:446pt'></td>
  <td width=259 style='width:194pt'></td>
 </tr>
 <![endif]>
</table>
