# Cilium - Configure eBPF for Optimal Performance

> Enable eBPF masquerading, disable host legacy routing, and properly configure BPF devices and cgroups for high-performance packet processing.

## Rules

- Enable `bpf.masquerade: true` (faster than iptables)
- Set `bpf.hostLegacyRouting: false` for eBPF datapath performance
- Set `bpf.tproxy: true` for transparent proxying (required for L7 policies)
- Configure `bpf.mapDynamicSizeRatio` for dynamic BPF map sizing (0.0025 = 0.25% of system memory)
- Enable `bpf.autoMount.enabled: true` for BPF filesystem
- Only list physical/bridge interfaces in `devices` -- never overlay interfaces
- Do not include in `devices`: wt0, wg0, vxlan.cilium, cilium_* interfaces
- Enable cgroup auto-mount with cgroup v2 path (`/sys/fs/cgroup`)
- Minimum kernel: 4.19, recommended: 5.4+
- Enable `wellKnownIdentities.enabled: true` for system services

## Example

```yaml
# eBPF core configuration
bpf:
  # Use eBPF for masquerading (faster than iptables)
  masquerade: true

  # Disable legacy host routing for eBPF datapath
  hostLegacyRouting: false

  # Dynamic BPF map sizing
  # Ratio of memory to allocate for BPF maps
  # 0.0025 = 0.25% of system memory
  mapDynamicSizeRatio: 0.0025

  # Enable transparent proxy for L7 policies
  tproxy: true

  # Auto-mount BPF filesystem
  autoMount:
    enabled: true

# Cgroup configuration
cgroup:
  autoMount:
    enabled: true
  # Cgroup v2 path (modern systems)
  hostRoot: /sys/fs/cgroup

# Devices to attach BPF programs
# Only physical/bridge interfaces, NOT overlay interfaces
devices:
  - eth0
  # - bond0  # If using bonding
  # - br0    # If using bridge

# Do NOT include:
# - wt0 (WireGuard)
# - wg0 (WireGuard)
# - vxlan.cilium (Cilium VXLAN - managed internally)
# - cilium_* interfaces

# L7 proxy configuration
l7Proxy: true

# Well-known identities for system services
wellKnownIdentities:
  enabled: true

# Kernel requirements check
# Cilium will validate kernel capabilities at startup
# Minimum: 4.19, Recommended: 5.4+
```
