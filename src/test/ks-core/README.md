### Upgrade from KSE 3.X

Preparing for upgrade.

```bash
ITEMS=(
    "globalroles.iam.kubesphere.io/anonymous"
    "globalroles.iam.kubesphere.io/authenticated"
    "globalroles.iam.kubesphere.io/platform-admin"
    "globalroles.iam.kubesphere.io/platform-regular"
    "globalroles.iam.kubesphere.io/platform-self-provisioner"
    "globalroles.iam.kubesphere.io/pre-registration"
    "globalrolebindings.iam.kubesphere.io/anonymous"
    "globalrolebindings.iam.kubesphere.io/authenticated"
    "globalrolebindings.iam.kubesphere.io/pre-registration"
    "workspacetemplate.tenant.kubesphere.io/system-workspace"
    "-n kubesphere-system configmap/kubesphere-config"
)
for i in "${ITEMS[@]}"
do
   kubectl label $i app.kubernetes.io/managed-by=Helm --overwrite
   kubectl annotate $i meta.helm.sh/release-name=ks-core --overwrite
   kubectl annotate $i meta.helm.sh/release-namespace=kubesphere-system --overwrite
done

items=$(kubectl get workspacetemplate -o jsonpath='{.items[*].metadata.name}')

for i in $items
do
    network_isolation=$(kubectl get workspacetemplate $i -o jsonpath='{.spec.template.spec.networkIsolation}')
    
    if [ "$network_isolation" == "true" ]; then
        kubectl annotate workspacetemplate $i kubesphere.io/network-isolate=enabled --overwrite
    fi
done
```