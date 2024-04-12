## v4.1.0

KubeSphere 企业版 4.1.0 是青云科技 KubeSphere 团队匠心打造的全新云原生操作系统，是 KubeSphere 企业版架构革新后的第一个全功能版本。

KubeSphere 企业版 4.1.0 在 KubeSphere LuBan 全新云原生可扩展开放架构的基础上，将 KubeSphere 企业版 v3 的全产品功能解耦，并基于可插拔的架构规范进行重构、升级。自此，各 KubeSphere 扩展组件可独立发版、迭代。用户可根据需要的产品能力安装扩展组件，保持平台的轻量与灵活，轻松定制“千人千面”的专属操作系统。

KubeSphere 企业版 4.1.0 内置了丰富全能的 KubeSphere 扩展市场。其中发布的扩展组件均经过严格审校，优质可控，覆盖云原生核心业务的方方面面。用户可自助式一键安装扩展组件，通过扩展中心一站式管理扩展组件的全生命周期。 此外，企业或个人开发者也可根据 KubeSphere LuBan 的开发规范，将自己的软件和服务上架到 KubeSphere 扩展市场进行分发与商业售卖，丰富多元的云原生应用生态。

### 新特性

- 基于全新微内核架构 KubeSphere LuBan 重构
- 内置 KubeSphere 扩展市场
- 支持通过扩展中心统一管理
- 支持 UI、API 扩展
- 支持通过 kubeconfig 一键导入 member 集群，无需手动在 member 集群部署 KubeSphere
- 支持 KubeSphere Service Account
- 支持基于 TOTP 的二次认证
- 支持动态扩展 Resource API
- 支持添加指定租户、集群、项目为快捷访问
- 支持通过容器终端进行文件上传和下载
- 支持适配不同厂商的云原生网关


### 优化

- 创建 workspace 时支持选取所有集群
- 优化 web kubectl，支持 pod 动态回收、窗口页默认选择当前集群、切换集群时支持模糊搜索
- 优化节点管理列表，将默认排序修改为升序
- 仅允许受信的 OAuth Client 直接使用用户名和密码对用户身份进行校验
- 精简 member 集群中部署的 agent 组件
- 拆分 KubeSphere Config 中部分配置作为独立的配置项
- 容器镜像 tag 搜索调整为按时间倒序进行排序
- console 支持编辑用户别名
- 支持集群列表调度状态的展示
- 支持配置字典详情页添加 binaryData 数据显示
- 重构 console 工作台管理页面

### 缺陷修复

- 修复 node terminal 一直显示 connecting 的问题
- 修复潜在的企业空间资源越权访问的问题
- 修复企业空间集群授权 API 潜在的越权问题
- 修复因错误配置导致会话异常登出的问题
- 修复添加镜像服务信息从指定仓库拉取镜像时异常的问题
- 编辑 secret 保留 ownerReferences 信息
- 修复 console 首次登录白屏和页面错误重定向问题
- 修复 Windows 环境下，console 选择框滚动问题

### API 更新

#### API 移除

v4.1 版本将停止提供以下已弃用的 API：

##### 多集群

`/API_PREFIX/clusters/{cluster}/API_GROUP/API_VERSION/...` 多集群代理请求 API 被移除。

* 请使用新的多集群代理请求路径规则代替，`/clusters/{cluster}/API_PREFIX/API_GROUP/API_VERSION/...`。

##### 访问控制

`iam.kubesphere.io/v1alpha2` API 版本被移除。

* 请使用 `iam.kubesphere.io/v1beta1` API 版本代替。
* `iam.kubesphere.io/v1beta1` 中的显著变化：
  * Role、RoleBinding、ClusterRole、ClusterRoleBinding 资源的 API Group 从 `rbac.authorization.k8s.io` 变更为 `iam.kubesphere.io`。

##### 多租户

`tenant.kubesphere.io/v1alpha1` 和 `tenant.kubesphere.io/v1alpha2` API 版本部分 API 被移除。

* 请使用 `tenant.kubesphere.io/v1beta1` API 版本代替。
* `tenant.kubesphere.io/v1beta1` 中的显著变化：
  * `Workspace` 中 `spec.networkIsolation` 被移除。

##### kubectl

* `/resources.kubesphere.io/v1alpha2/users/{user}/kubectl` 接口已移除，终端相关操作无需再调用该接口
* 用户 web kubectl 终端 API 路径从 `/kapis/terminal.kubesphere.io/v1alpha2/namespaces/{namespace}/pods/{pod}/exec` 调整为 `/kapis/terminal.kubesphere.io/v1alpha2/users/{user}/kubectl`

##### gateway

`gateway.kubesphere.io/v1alpha1` API 版本被移除。

* 配置 Ingress 查询相关网关的 API 调整为 `/kapis/gateway.kubesphere.io/v1alpha2/namespaces/{namespace}/availableingressclassscopes`。

#### API 弃用

以下 API 标记为弃用，将在未来的版本中移除：

- Cluster validation API
- Config configz API
- OAuth token review API
- Operations job rerun API
- Resources v1alpha2 API
- Resources v1alpha3 API
- Tenant v1alpha3 API
- Legacy version API

### 已知问题

- LDAP Identity Provider 将在后续版本中支持
- 企业空间部门管理将在后续版本中支持

## 其他

- 默认移除除英文和简体中文之外的所有语言选项
- 移除「系统组件」相关内容
