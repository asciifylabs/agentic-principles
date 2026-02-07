# Use Labels and Annotations Consistently

> Establish and enforce labeling conventions using `app.kubernetes.io/*` recommended labels on all resources.

## Rules

- **Labels**: Use for selection, grouping, and filtering (used by selectors)
- **Annotations**: Use for non-identifying metadata (URLs, descriptions, tool config)
- Use recommended `app.kubernetes.io/*` labels on all resources
- Include labels for: app name, version, component, environment, team/owner
- Use annotations for ingress config, Prometheus scraping, etc.
- Do not change labels used in selectors (this is disruptive)
- Labels are limited to 63 characters

### Recommended Labels

| Label | Purpose |
|-------|---------|
| `app.kubernetes.io/name` | Application name |
| `app.kubernetes.io/instance` | Instance identifier |
| `app.kubernetes.io/version` | Application version |
| `app.kubernetes.io/component` | Component type (frontend, backend, database) |
| `app.kubernetes.io/part-of` | Higher-level application |
| `app.kubernetes.io/managed-by` | Tool managing resource (helm, argocd) |

## Example

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
  labels:
    app.kubernetes.io/name: api-server
    app.kubernetes.io/instance: api-server-prod
    app.kubernetes.io/version: "1.2.3"
    app.kubernetes.io/component: backend
    app.kubernetes.io/part-of: payments-platform
    app.kubernetes.io/managed-by: argocd
    team: platform
    environment: production
    cost-center: payments
  annotations:
    description: "Main API server for payments platform"
    oncall: "platform-team@company.com"
    prometheus.io/scrape: "true"
    prometheus.io/port: "9090"
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: api-server
      app.kubernetes.io/instance: api-server-prod
  template:
    metadata:
      labels:
        app.kubernetes.io/name: api-server
        app.kubernetes.io/instance: api-server-prod
        app.kubernetes.io/version: "1.2.3"
```
