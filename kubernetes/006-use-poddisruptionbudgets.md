# Use PodDisruptionBudgets for High Availability

> Define PodDisruptionBudgets for all critical workloads to guarantee minimum availability during voluntary disruptions.

## Rules

- Specify `minAvailable` OR `maxUnavailable` (not both)
- Use percentages for workloads with variable replica counts (e.g., HPA)
- Always create PDBs for production deployments with replicas > 1
- Do not set PDBs that block all disruption (e.g., `minAvailable` = total replicas) -- this blocks node drains
- For stateful workloads, set `minAvailable` to maintain quorum
- PDBs only protect against voluntary disruptions (node drains, upgrades) -- not involuntary ones (node failure)
- Test PDB configuration during maintenance windows

## Example

```yaml
# Percentage-based (recommended for HPA workloads)
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: api-server-pdb
  namespace: production
spec:
  minAvailable: 50%
  selector:
    matchLabels:
      app.kubernetes.io/name: api-server

---
# Absolute number-based
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: cache-pdb
  namespace: production
spec:
  maxUnavailable: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: redis-cache

---
# For stateful workloads (e.g., etcd, databases)
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: etcd-pdb
spec:
  minAvailable: 2  # Maintain quorum (for 3-node cluster)
  selector:
    matchLabels:
      app: etcd
```
