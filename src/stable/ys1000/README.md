
# YS1000 Helm Chart

## 简介

YS1000(Helm chart) 使用 **Helm** 包管理工具在 **Kubernetes** (K8S) 集群中安装和部署[银数多云数据管理软件](https://www.jibudata.com/)。 

## 先决条件

- Kuberentes 版本支持范围 [1.15, 1.21]
- Helm 版本支持 >= 3.5
- 在线安装请确保K8S集群节点可以访问和拉取容器镜像 (container images)
- 可用的S3 (AWS S3兼容) 对象存储

## 安装 

1. 您可以使用以下两种方法进行安装:

   **注意-1**: 为确保安装成功，请设置必需的的配置参数， 具体信息请参考安装手册配置章节 <br>
   **注意-2**: 需要在安装本软件之前准备好 S3 (AWS S3兼容) 对象存储环境，下文基于本地安装的 [minio](https://min.io/) 为例进行说明 <br>
   **注意-3**: Web访问方式支持以Ingress, NodePort 或者 Service 方式在安装时进行配置 <br>

   1. 通过命令行方式安装:

      使用**Helm**命令行参数`--set key=value[,key=value] `来指定必要的配置参数，例如: 

      ```bash
      helm install ys1000 stable/ys1000  \
          --namespace qiming-migration --create-namespace \
          --set s3Config.provider=aws --set s3Config.name=minio \
          --set s3Config.accessKey=minio --set s3Config.secretKey=passw0rd \
          --set s3Config.bucket=test --set s3Config.s3Url=http://172.16.0.10:30170
      ...
      
      
      NAME: ys1000
      LAST DEPLOYED: Sun Oct 31 18:15:46 2021
      NAMESPACE: qiming-migration
      STATUS: deployed
      REVISION: 1
      NOTES:
      1. Check the application status Ready by running these commands:
        NOTE: It may take a few minutes to pull docker images.
              You can watch the status of by running `kubectl --namespace qiming-migration get migconfigs.migration.yinhestor.com -w`
        kubectl --namespace qiming-migration get migconfigs.migration.yinhestor.com
      
      2. After status is ready, get the application URL by running these commands:
        export POD_NAME=$(kubectl get pods --namespace qiming-migration -l "app.kubernetes.io/component=ui-discovery" -o jsonpath="{.items[0].metadata.name}")
        export CONTAINER_PORT=$(kubectl get pod --namespace qiming-migration $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
        echo "Visit http://127.0.0.1:8080 to use your application"
        kubectl --namespace qiming-migration port-forward $POD_NAME 8080:$CONTAINER_PORT
      
      3. Login web UI with the token by running these commands:
        export SECRET=$(kubectl -n qiming-migration get secret | (grep qiming-operator |grep -v helm || echo "$_") | awk '{print $1}')
        export TOKEN=$(kubectl -n qiming-migration describe secrets $SECRET |grep token: | awk '{print $2}')
        echo $TOKEN
      ```

   2. 通过 **YAML** 文件指定参数进行安装, 在 **values.yaml** 配置文件中设置或者修改必要的配置参数。

      1. 下载 values.yaml 模板配置文件

      2. 修改配置文件中的配置参数

      3. 通过 ` -f values.yaml ` 来指定配置文件进行安装， 如下示例：

      ```bash
      # step 1: generate default values.yaml
      helm inspect values stable/ys1000 > values.yaml
      
      # step 2: fill required arguments in values.yaml
      vim values.yaml
      
      # step 3: install by specifying the values.yaml
      helm install ys1000 stable/ys1000 --namespace qiming-migration -f values.yaml --generate-name
      ```

3. 获取已安装的软件的运行状态以及访问信息

   1. 使用上述安装结束后 `NOTES` 中的第一条命令来查询软件的运行状态，使用可选 `-w` 参数观察软件初始化过程更新。

      **注意**：软件在初次安装时，需要一段时间下载容器镜像到K8S节点上，具体时间取决于镜像拉取速度。

      当`PHASE` 状态变成 `Ready`，表明软件初始化完成。

      如果变成 `Error` ，则说明初始化过程失败，需要查找错误原因。

      ```bash
      [root@gyj-dev src]# kubectl --namespace qiming-migration get migconfigs.migration.yinhestor.com
      NAME            AGE   PHASE   CREATED AT             VERSION
      qiming-config   13m   Ready   2021-10-31T10:29:57Z   v2.0.4
      ```

   2. 使用上述安装结束后 `NOTES` 中的第二条和第三条命令获取程序访问地址(Web URL) 以及登录所需的认证令(token) 

      **注意**：软件通过K8S Service 来暴露对外访问接口；Web URL 基于K8S 配置以及安装中指定的参数不同， 暴露出的访问地址不同，支持类型包括: `kubectl proxy`， `ingress` 和  `nodeport`，下文以 `nodeport` 安装方式为例:

      ```
      [root@remote-dev ~]# export NODE_PORT=$(kubectl get --namespace qiming-migration -o jsonpath="{.spec.ports[0].nodePort}" services ui-service-default )
      [root@remote-dev ~]# export NODE_IP=$(kubectl get nodes --namespace qiming-migration -o jsonpath="{.items[0].status.addresses[0].address}")
      
      [root@remote-dev ~]# echo http://$NODE_IP:$NODE_PORT
      http://192.168.0.2:31151
      
      [root@remote-dev ~]# export SECRET=$(kubectl -n qiming-migration get secret | (grep qiming-operator |grep -v helm || echo "$_") | awk '{print $1}')
      [root@remote-dev ~]# export TOKEN=$(kubectl -n qiming-migration describe secrets $SECRET |grep token: | awk '{print $2}')
      
      [root@remote-dev ~]# echo $TOKEN
      eyJh....
      ```

   3. 使用命令 `helm list -n <NAMESPACE> ` 来显示当前安装的软件信息，例如：

      ```bash
      NAME    NAMESPACE               REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
      ys1000  qiming-migration        1               2021-10-31 18:29:57.355147222 +0800 CST deployed        qiming-operator-2.0.4   2.0.4 
      ```

## 卸载

1. 卸载已安装的 Helm chart

   指定当前已安装的软件名`release name` 和 软件所在的命名空间`namespace` 

   ```bash
   [root@remote-dev ~]# helm list -n qiming-migration
   NAME    NAMESPACE               REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
   ys1000  qiming-migration        1               2021-10-31 18:29:57.355147222 +0800 CST deployed        qiming-operator-2.0.4   2.0.4 
   
   [root@remote-dev ~]# helm uninstall ys1000 -n qiming-migration
   release "ys1000" uninstalled
   ```

   **注意-1**:  备份资源CRs 仍然保留在安装所在的命名空间中，上例中为 `qiming-migration`，已防止误操作导致数据丢失。
   **注意-2**:  `velero` 组件和资源对象默认仍然保留在命名空间`qiming-backend`中

   如果您确定需要删除 `velero` 和相关应用备份数据记录，可以通过下列命令在每个Kubernetes 集群上分别运行，进行清除操作：

   ```bash
   kubectl delete ns qiming-backend
	
   kubectl delete clusterrolebindings.rbac.authorization.k8s.io velero-qiming-backend

   kubectl delete crds -l component=velero
   ```

	  
## 配置

此表列出安装阶段所需的必要和可选参数：

| 参数名 | 描述 | 示例 | 类型 |
| --- | --- | --- | --- |
| migconfig.keys     |    YS1000软件许可证，默认免费版可管理2个集群 |  请您联系support@jibudata.com更新License | 可选 |
| service.type       |    Web访问所配置的服务类型              |   --set service.type=NodePort             | 可选  |
| ingress.enable     |   通过Ingress访问Web界面               |   --set ingress.enable=true               | 可选  |
| ingress.hostname   |   设置Ingress对应的域名               |   --set ingress.hostname=ys1000.l          | 可选  |
| s3Config.provider  |   S3提供商                         |   --set s3Config.provider=aws                | 必要  |
| s3Config.name      |    所配置的S3服务名字， 也即数据备份仓库名字 |   --set s3Config.name=minio             | 必要  | 
| s3Config.accessKey |    访问S3所需要的access key               |   --set s3Config.accessKey=minio      | 必要  |
| s3Config.secretKey |    访问S3所需要的secret key        |    --set s3Config.secretKey=passw0rd         | 必要  |
| s3Config.bucket    |   访问S3的bucket name             |   --set s3Config.bucket=test                | 必要  |
| s3Config.s3Url     |    S3 URL                |   --set s3Config.s3Url=http://172.16.0.10:30170     | 必要  |
| velero.disableSnapshot | 如果当前K8S环境存储不支持快照，可设置此选项 | --set velero.disableSnapshot=true  | 可选 |
