# Cilium - Configure MTU Properly

> Calculate and set MTU accounting for all encapsulation layers to prevent packet fragmentation and connectivity failures.

## Rules

- Formula: `Final MTU = Physical MTU - Overlay Overhead - Cilium Overhead - Safety Margin`
- Enable path MTU discovery when possible
- Enable `enableIPv4FragmentsTracking: true` for overlay networks
- Test MTU with actual traffic patterns
- Monitor for ICMP "fragmentation needed" messages
- Do not include overlay interfaces (wt0, wg0, vxlan.cilium) in the `devices` list
- Set `bpf.hostLegacyRouting: false` for performance

### Common Overhead Values

| Layer | Overhead |
|-------|----------|
| VXLAN | 50 bytes |
| Geneve | 50 bytes |
| WireGuard | 60-80 bytes |
| IPsec | 50-70 bytes |
| IPv6 | 20 bytes (vs IPv4) |

### Example Calculations

- Standard network (1500 MTU) with VXLAN: `1500 - 50 = 1450`
- WireGuard (1280 MTU) with VXLAN: `1280 - 50 - 30 = 1200`
- Cloud (jumbo frames 9000) with VXLAN: `9000 - 50 = 8950`

## Example

```yaml
# Cilium configuration for WireGuard + VXLAN
# Physical interface: WireGuard with MTU 1280
# Cilium tunnel: VXLAN (50 bytes overhead)
# Safety margin: 30 bytes
MTU: 1200

# Enable fragment tracking for overlay networks
# Required when packets may be fragmented before reaching Cilium
enableIPv4FragmentsTracking: true

# BPF settings for proper packet handling
bpf:
  masquerade: true
  # Disable host legacy routing for performance
  hostLegacyRouting: false

# Specify devices to attach BPF programs
# Don't include overlay interfaces (wt0, wg0) to avoid interference
devices:
  - eth0
```
