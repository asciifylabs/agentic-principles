# Use Liveness and Readiness Probes

> Configure appropriate health probes for all containers so Kubernetes can detect failures and manage traffic routing.

## Rules

- **Readiness probe**: Determines if a pod should receive traffic -- use for zero-downtime deployments
- **Liveness probe**: Determines if a container should be restarted -- keep these lightweight
- **Startup probe**: Use for slow-starting applications (Kubernetes 1.18+) to avoid premature liveness failures
- Choose appropriate probe type: HTTP, TCP, or exec
- Set sensible timeouts and thresholds
- Do not put expensive checks in liveness probes (they run frequently and can cause restart loops)
- Readiness probes can be more comprehensive than liveness probes

## Example

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-app
spec:
  containers:
    - name: app
      image: web-app:v1.0.0
      ports:
        - containerPort: 8080

      # Check if app is ready to serve traffic
      readinessProbe:
        httpGet:
          path: /health/ready
          port: 8080
        initialDelaySeconds: 5
        periodSeconds: 10
        successThreshold: 1
        failureThreshold: 3

      # Check if app is alive (restart if not)
      livenessProbe:
        httpGet:
          path: /health/live
          port: 8080
        initialDelaySeconds: 15
        periodSeconds: 20
        timeoutSeconds: 5
        failureThreshold: 3

      # For slow-starting apps
      startupProbe:
        httpGet:
          path: /health/live
          port: 8080
        failureThreshold: 30
        periodSeconds: 10
```
