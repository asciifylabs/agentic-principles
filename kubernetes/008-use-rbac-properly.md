# Use RBAC with Least Privilege

> Implement RBAC following least privilege -- never use cluster-admin for applications, create namespace-scoped Roles with specific permissions.

## Rules

- Never use `cluster-admin` for applications or regular users
- Prefer namespace-scoped Roles over cluster-wide ClusterRoles
- Define specific resource and verb permissions -- avoid wildcards (`*`)
- Create dedicated ServiceAccounts per application
- Use RoleBindings to assign Roles to ServiceAccounts
- Audit RBAC permissions regularly
- Use RBAC aggregation for composable roles
- Set `automountServiceAccountToken: true` only when the pod actually needs API access

## Example

```yaml
# Dedicated ServiceAccount for application
apiVersion: v1
kind: ServiceAccount
metadata:
  name: api-server
  namespace: production

---
# Namespace-scoped Role with specific permissions
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: api-server-role
  namespace: production
rules:
  # Read ConfigMaps and Secrets
  - apiGroups: [""]
    resources: ["configmaps", "secrets"]
    verbs: ["get", "list", "watch"]
  # Manage own pods (for leader election, etc.)
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list", "watch"]
  # Create events
  - apiGroups: [""]
    resources: ["events"]
    verbs: ["create", "patch"]

---
# Bind role to ServiceAccount
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: api-server-binding
  namespace: production
subjects:
  - kind: ServiceAccount
    name: api-server
    namespace: production
roleRef:
  kind: Role
  name: api-server-role
  apiGroup: rbac.authorization.k8s.io

---
# Use ServiceAccount in Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
  namespace: production
spec:
  template:
    spec:
      serviceAccountName: api-server
      automountServiceAccountToken: true  # Only if needed
      containers:
        - name: api
          image: api-server:v1
```
