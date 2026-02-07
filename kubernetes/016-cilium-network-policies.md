# Cilium - Use CiliumNetworkPolicies for Advanced Security

> Use CiliumNetworkPolicy for L7 filtering, DNS-based egress rules, and identity-based security beyond what standard NetworkPolicy supports.

## Rules

- Use standard Kubernetes NetworkPolicy for basic L3/L4 rules (portable across CNIs)
- Use CiliumNetworkPolicy (CNP) for L7 HTTP/gRPC filtering, DNS-based policies, and advanced features
- Use CiliumClusterwideNetworkPolicy (CCNP) for cluster-wide rules
- Implement default-deny with explicit allow rules
- L7 policies add latency (proxy required) -- only use when needed
- Available Cilium-specific features:
  - L7 HTTP/gRPC filtering (methods, paths, headers)
  - DNS-based egress policies (`toFQDNs`) -- no hardcoded IPs
  - Entity-based rules (`world`, `cluster`, `host`)
  - CIDR-based rules for external services
  - Port ranges and named ports

## Example

```yaml
# Default deny with DNS and health check exceptions
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: default-deny
  namespace: production
spec:
  endpointSelector: {}
  egress:
    # Allow DNS
    - toEndpoints:
        - matchLabels:
            k8s:io.kubernetes.pod.namespace: kube-system
            k8s-app: kube-dns
      toPorts:
        - ports:
            - port: "53"
              protocol: UDP

---
# L7 HTTP policy
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: api-http-policy
  namespace: production
spec:
  endpointSelector:
    matchLabels:
      app: api-server
  ingress:
    - fromEndpoints:
        - matchLabels:
            app: frontend
      toPorts:
        - ports:
            - port: "8080"
              protocol: TCP
          rules:
            http:
              - method: GET
                path: "/api/v1/.*"
              - method: POST
                path: "/api/v1/orders"

---
# DNS-based egress policy (FQDN)
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: external-api-egress
  namespace: production
spec:
  endpointSelector:
    matchLabels:
      app: payment-service
  egress:
    - toFQDNs:
        - matchName: "api.stripe.com"
        - matchPattern: "*.amazonaws.com"
      toPorts:
        - ports:
            - port: "443"
              protocol: TCP

---
# Cluster-wide policy
apiVersion: cilium.io/v2
kind: CiliumClusterwideNetworkPolicy
metadata:
  name: deny-external-except-allowed
spec:
  endpointSelector:
    matchLabels:
      allow-external: "true"
  egress:
    - toEntities:
        - world
```
