# Cilium - Configure Masquerading Correctly

> Enable eBPF masquerading for external traffic and define non-masquerade CIDRs to preserve pod IPs for internal communication.

## Rules

- Enable `bpf.masquerade: true` for eBPF-based masquerading (faster than iptables)
- Enable `enableIPv4Masquerade: true` for external traffic
- Use IP Masquerade Agent for fine-grained control over which CIDRs are masqueraded
- Define non-masquerade CIDRs for all internal networks (pod CIDR, service CIDR, VPN/overlay CIDR)
- Traffic to non-masquerade CIDRs keeps original pod IP (important for network policies and logging)
- Traffic to all other destinations (internet) is masqueraded to node IP
- Set `masqLinkLocal: false` to skip link-local addresses
- For tunnel mode, use SNAT load balancer mode for symmetric routing
- Update non-masquerade CIDRs when adding new internal networks

## Example

```yaml
# Enable eBPF masquerading
bpf:
  masquerade: true

# Enable IPv4 masquerade for external traffic
enableIPv4Masquerade: true
enableIPv6Masquerade: false  # Disable if not using IPv6

# IP Masquerade Agent for fine-grained control
ipMasqAgent:
  enabled: true
  config:
    # Traffic to these CIDRs keeps original pod IP
    nonMasqueradeCIDRs:
      - 10.42.0.0/16    # Pod CIDR
      - 10.43.0.0/16    # Service CIDR
      - 100.64.0.0/10   # WireGuard/VPN overlay (if applicable)
      - 172.16.0.0/12   # Private network (if applicable)
    # Don't masquerade link-local traffic
    masqLinkLocal: false

# For tunnel mode, ensure symmetric routing
# with SNAT load balancer mode
loadBalancer:
  mode: snat

# Devices for BPF attachment (source of masqueraded traffic)
devices:
  - eth0  # Primary interface for external traffic
```
