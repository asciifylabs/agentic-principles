# Use Network Policies for Zero-Trust Security

> Implement default-deny network policies per namespace, then explicitly allow only required traffic flows.

## Rules

- Start with a default-deny policy per namespace (both ingress and egress)
- Explicitly allow only required traffic flows
- Use pod selectors to target specific workloads
- Separate ingress (incoming) and egress (outgoing) rules
- Always allow DNS egress (UDP port 53) for service discovery
- Requires a CNI that supports network policies (Cilium, Calico)
- Document network policies alongside application deployments
- Test policies in non-production environments first

## Example

```yaml
# Default deny all traffic in namespace
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: production
spec:
  podSelector: {}
  policyTypes:
    - Ingress
    - Egress

---
# Allow specific traffic for API server
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: api-server-policy
  namespace: production
spec:
  podSelector:
    matchLabels:
      app: api-server
  policyTypes:
    - Ingress
    - Egress
  ingress:
    # Allow from ingress controller
    - from:
        - namespaceSelector:
            matchLabels:
              name: ingress-nginx
          podSelector:
            matchLabels:
              app: ingress-nginx
      ports:
        - protocol: TCP
          port: 8080
  egress:
    # Allow DNS
    - to:
        - namespaceSelector: {}
          podSelector:
            matchLabels:
              k8s-app: kube-dns
      ports:
        - protocol: UDP
          port: 53
    # Allow to database
    - to:
        - podSelector:
            matchLabels:
              app: postgres
      ports:
        - protocol: TCP
          port: 5432
```
