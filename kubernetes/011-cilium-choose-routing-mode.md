# Cilium - Choose the Right Routing Mode

> Select native routing for maximum performance when the network supports it, or tunnel mode (VXLAN/Geneve) for universal compatibility.

## Rules

- **Native routing** (`routingMode: native`): Best performance, no encapsulation overhead, requires network support (BGP, cloud CNI integration), pod IPs must be routable
- **Tunnel/VXLAN** (`routingMode: tunnel`, `tunnelProtocol: vxlan`): Widely compatible, works over any IP network, ~50 bytes overhead
- **Tunnel/Geneve** (`routingMode: tunnel`, `tunnelProtocol: geneve`): More flexible, supports metadata, preferred for new tunnel deployments
- Use `autoDirectNodeRoutes: true` with native routing on flat networks
- Cloud providers: use native routing with cloud integration
- On-premises with BGP: use native routing
- VPN/overlay networks: use tunnel mode (VXLAN)
- Unknown/mixed environments: default to tunnel mode for compatibility

## Example

```yaml
# Tunnel mode for overlay networks (e.g., WireGuard)
routingMode: tunnel
tunnelProtocol: vxlan
tunnelPort: 8472
autoDirectNodeRoutes: false

# Calculate MTU: underlying_mtu - vxlan_overhead - safety_margin
# WireGuard (1280) - VXLAN (50) - safety (30) = 1200
MTU: 1200

---
# Native routing for cloud/BGP environments
routingMode: native
autoDirectNodeRoutes: true
ipam:
  mode: cluster-pool  # or kubernetes

# Use BGP for route advertisement
bgpControlPlane:
  enabled: true
```
