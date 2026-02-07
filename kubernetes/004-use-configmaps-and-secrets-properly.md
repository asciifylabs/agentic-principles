# Use ConfigMaps and Secrets Properly

> Externalize all configuration using ConfigMaps for non-sensitive data and Secrets for sensitive data -- never hardcode into images.

## Rules

- Use ConfigMaps for non-sensitive configuration data
- Use Secrets for sensitive data (passwords, tokens, certificates)
- Mount as files or environment variables depending on use case
- Use immutable ConfigMaps/Secrets when possible for performance
- Never commit Secrets to version control
- Consider external secret management (Vault, External Secrets Operator)
- Use sealed-secrets or SOPS for GitOps workflows
- Base64 encoding in Secrets is NOT encryption -- anyone with RBAC access can read them
- ConfigMap/Secret size is limited to 1MB
- Changes require pod restart unless using a reloader

## Example

```yaml
# ConfigMap for application config
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: production
data:
  LOG_LEVEL: "info"
  MAX_CONNECTIONS: "100"
  config.yaml: |
    server:
      port: 8080
    cache:
      ttl: 300

---
# Secret for sensitive data
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
  namespace: production
type: Opaque
stringData:  # Use stringData for clarity (auto base64 encoded)
  DATABASE_PASSWORD: "supersecret"
  API_KEY: "abc123"

---
# Pod using both
apiVersion: v1
kind: Pod
metadata:
  name: app
spec:
  containers:
    - name: app
      image: myapp:v1
      envFrom:
        - configMapRef:
            name: app-config
        - secretRef:
            name: app-secrets
      volumeMounts:
        - name: config-volume
          mountPath: /etc/config
  volumes:
    - name: config-volume
      configMap:
        name: app-config
        items:
          - key: config.yaml
            path: config.yaml
```
