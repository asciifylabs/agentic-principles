# Use Namespaces for Isolation

> Logically separate workloads using namespaces to enforce security boundaries, resource quotas, and RBAC.

## Rules

- Create dedicated namespaces for each application or team
- Use namespaces to separate environments (dev, staging, prod) when using a single cluster
- Apply resource quotas and limit ranges per namespace
- Use network policies scoped to namespaces
- Implement RBAC policies at the namespace level
- Reserve `kube-system` and `kube-public` for system components only
- Remember that some resources are cluster-scoped (CRDs, ClusterRoles) and cannot be namespaced

## Example

```yaml
# Create namespace with labels
apiVersion: v1
kind: Namespace
metadata:
  name: payments-service
  labels:
    team: platform
    environment: production
    cost-center: payments

---
# Apply resource quota
apiVersion: v1
kind: ResourceQuota
metadata:
  name: payments-quota
  namespace: payments-service
spec:
  hard:
    requests.cpu: "10"
    requests.memory: 20Gi
    limits.cpu: "20"
    limits.memory: 40Gi
    pods: "50"
```
