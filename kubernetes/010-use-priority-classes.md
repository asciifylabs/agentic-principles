# Use PriorityClasses for Workload Prioritization

> Define PriorityClasses to ensure critical workloads are scheduled first and protected from eviction during resource pressure.

## Rules

- Use built-in `system-cluster-critical` and `system-node-critical` for system components
- Create custom PriorityClasses for application tiers (high, standard, low)
- Assign higher priority to production workloads
- Use lower priority for batch jobs and development workloads
- Set `preemptionPolicy: PreemptLowerPriority` for critical workloads
- Set `preemptionPolicy: Never` for batch/low-priority workloads to avoid evicting others
- Do not set all workloads to high priority -- this defeats the purpose
- Set one PriorityClass as `globalDefault: true` for standard workloads

## Example

```yaml
# High priority for production workloads
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: production-high
value: 1000000
globalDefault: false
preemptionPolicy: PreemptLowerPriority
description: "High priority for production-critical workloads"

---
# Medium priority for standard production
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: production-standard
value: 100000
globalDefault: true  # Default for all pods
preemptionPolicy: PreemptLowerPriority
description: "Standard priority for production workloads"

---
# Low priority for batch/dev workloads
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: batch-low
value: 1000
globalDefault: false
preemptionPolicy: Never  # Don't evict other pods
description: "Low priority for batch jobs and dev workloads"

---
# Use in deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: payment-processor
spec:
  template:
    spec:
      priorityClassName: production-high
      containers:
        - name: processor
          image: payment-processor:v1
```
