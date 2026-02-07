# Use Pod Security Standards

> Enforce Pod Security Standards at the namespace level -- use `restricted` for production, `baseline` for legacy apps during migration.

## Rules

- Apply Pod Security Admission (PSA) labels to namespaces to enforce standards
- **Privileged**: Unrestricted -- only for system workloads
- **Baseline**: Minimally restrictive -- prevents known privilege escalations
- **Restricted**: Heavily restricted -- use for production workloads
- Configure security contexts explicitly in pod specs
- Do not run containers as root
- Always set `allowPrivilegeEscalation: false`
- Use `readOnlyRootFilesystem: true` and mount writable paths as emptyDir
- Drop all capabilities with `capabilities.drop: [ALL]`
- Set `seccompProfile.type: RuntimeDefault`

## Example

```yaml
# Enable Pod Security Standards on namespace
apiVersion: v1
kind: Namespace
metadata:
  name: production
  labels:
    # Enforce restricted standard
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/enforce-version: latest
    # Warn on violations (useful for migration)
    pod-security.kubernetes.io/warn: restricted
    pod-security.kubernetes.io/audit: restricted

---
# Pod following restricted standard
apiVersion: v1
kind: Pod
metadata:
  name: secure-app
  namespace: production
spec:
  securityContext:
    runAsNonRoot: true
    seccompProfile:
      type: RuntimeDefault
  containers:
    - name: app
      image: myapp:v1
      securityContext:
        allowPrivilegeEscalation: false
        readOnlyRootFilesystem: true
        runAsNonRoot: true
        runAsUser: 1000
        runAsGroup: 1000
        capabilities:
          drop:
            - ALL
      volumeMounts:
        - name: tmp
          mountPath: /tmp
  volumes:
    - name: tmp
      emptyDir: {}
```
