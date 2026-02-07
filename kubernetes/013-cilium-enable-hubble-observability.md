# Cilium - Enable Hubble for Network Observability

> Enable Hubble with relay for cluster-wide network visibility, flow inspection, and Prometheus metrics integration.

## Rules

- Enable Hubble with relay for cluster-wide visibility
- Configure relevant metrics: `dns:query`, `drop`, `tcp`, `flow`, `port-distribution`, `icmp`
- Enable `httpV2` metrics with context labels for L7 visibility (adds overhead)
- Use Hubble CLI for real-time flow inspection (`hubble observe`)
- Enable Hubble UI for visual flow analysis (optional, adds resource cost)
- Export metrics to Prometheus/Grafana via serviceMonitor
- Set resource requests/limits on relay pods

## Example

```yaml
# Hubble configuration
hubble:
  enabled: true

  # Relay for cluster-wide observability
  relay:
    enabled: true
    replicas: 1
    resources:
      requests:
        cpu: 100m
        memory: 128Mi

  # UI for visual analysis (optional)
  ui:
    enabled: true
    replicas: 1

  # Metrics for Prometheus integration
  metrics:
    enabled:
      - dns:query
      - drop
      - tcp
      - flow
      - port-distribution
      - icmp
      # L7 HTTP metrics with context labels
      - httpV2:exemplars=true;labelsContext=source_ip,source_namespace,source_workload,destination_ip,destination_namespace,destination_workload,traffic_direction

    serviceMonitor:
      enabled: true  # If using Prometheus Operator

# Usage examples:
# hubble observe --namespace production
# hubble observe --verdict DROPPED
# hubble observe --from-pod frontend --to-pod backend
# hubble observe --protocol TCP --port 443
```
