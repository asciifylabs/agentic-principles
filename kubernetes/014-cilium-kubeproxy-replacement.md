# Cilium - Use Kube-Proxy Replacement

> Enable Cilium's eBPF-based kube-proxy replacement for better service routing performance and scalability over iptables.

## Rules

- Set `kubeProxyReplacement: true` for full replacement
- Disable kube-proxy during cluster installation (cannot run alongside)
- Configure `k8sServiceHost` and `k8sServicePort` to point to the control plane
- Use SNAT load balancer mode for overlay/tunnel networks
- Use DSR (Direct Server Return) for native routing with network support
- Enable socket-level load balancing for local traffic optimization
- Requires kernel 5.x+ for full eBPF feature support
- For RKE2: configure Cilium before cluster init
- Set health check endpoint: `kubeProxyReplacementHealthzBindAddr: "0.0.0.0:10256"`

## Example

```yaml
# Full kube-proxy replacement
kubeProxyReplacement: true
kubeProxyReplacementHealthzBindAddr: "0.0.0.0:10256"

# Kubernetes API server endpoint
k8sServiceHost: "10.0.0.1"  # Or control plane VIP
k8sServicePort: 6443

# Load balancer configuration
loadBalancer:
  mode: snat  # Use SNAT for overlay/tunnel networks
  # mode: dsr  # Use DSR for native routing with network support

# NodePort support
nodePort:
  enabled: true
  # bindProtection: true  # Prevent binding to NodePort range

# Socket-level load balancing
socketLB:
  enabled: true
  hostNamespaceOnly: true  # Only for host-network pods

# External IPs
externalIPs:
  enabled: true

# HostPort support
hostPort:
  enabled: true

# Local redirect policy for node-local services
localRedirectPolicy: true
```
