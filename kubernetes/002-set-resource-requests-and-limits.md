# Set Resource Requests and Limits

> Always define resource requests and limits for every container to ensure predictable scheduling and prevent resource starvation.

## Rules

- Set **requests** (minimum guaranteed resources) based on normal operating needs
- Set **limits** (maximum resources) to prevent runaway consumption
- For critical workloads, set requests equal to limits (Guaranteed QoS class)
- Use LimitRange to enforce defaults per namespace
- Monitor actual usage and adjust values based on metrics
- Do not over-provision (wastes resources) or under-provision (causes throttling/OOM kills)
- Understand QoS classes: Guaranteed (requests=limits), Burstable (requests<limits), BestEffort (no requests/limits)

## Example

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: api-server
spec:
  containers:
    - name: api
      image: api-server:v1.2.3
      resources:
        requests:
          cpu: 100m      # 0.1 CPU cores
          memory: 256Mi  # 256 MiB RAM
        limits:
          cpu: 500m      # 0.5 CPU cores
          memory: 512Mi  # 512 MiB RAM

---
# Namespace-level defaults
apiVersion: v1
kind: LimitRange
metadata:
  name: default-limits
  namespace: production
spec:
  limits:
    - default:
        cpu: 500m
        memory: 512Mi
      defaultRequest:
        cpu: 100m
        memory: 256Mi
      type: Container
```
