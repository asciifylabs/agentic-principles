# Cilium - Enable Bandwidth Manager for QoS

> Enable Cilium's eBPF bandwidth manager with BBR congestion control to enforce per-pod bandwidth limits and prevent noisy neighbors.

## Rules

- Enable `bandwidthManager.enabled: true` for pod bandwidth limits
- Enable `bandwidthManager.bbr: true` for improved throughput (especially over high-latency/lossy links)
- Use standard Kubernetes annotations to set per-pod bandwidth limits:
  - `kubernetes.io/ingress-bandwidth: "10M"` (download limit)
  - `kubernetes.io/egress-bandwidth: "50M"` (upload limit)
- Requires kernel 5.1+ for bandwidth manager
- Requires kernel 5.18+ for BBR with EDT (Earliest Departure Time)
- Limits are per-pod, not per-container
- Ensure proper `devices` configuration

## Example

```yaml
# Cilium bandwidth manager configuration
bandwidthManager:
  enabled: true
  # Enable BBR congestion control
  # Improves throughput, especially over high-latency/lossy links
  bbr: true

# Pod with bandwidth limits
apiVersion: v1
kind: Pod
metadata:
  name: bandwidth-limited-app
  annotations:
    # Limit ingress (download) to 100 Mbps
    kubernetes.io/ingress-bandwidth: "100M"
    # Limit egress (upload) to 50 Mbps
    kubernetes.io/egress-bandwidth: "50M"
spec:
  containers:
    - name: app
      image: myapp:v1
      resources:
        requests:
          cpu: 100m
          memory: 128Mi

---
# Deployment with bandwidth limits
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rate-limited-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: rate-limited
  template:
    metadata:
      labels:
        app: rate-limited
      annotations:
        kubernetes.io/ingress-bandwidth: "50M"
        kubernetes.io/egress-bandwidth: "25M"
    spec:
      containers:
        - name: service
          image: service:v1
```
