# Test Manifests and Charts

> Validate Kubernetes manifests and Helm charts before deploying to catch misconfigurations, policy violations, and regressions.

## Rules

- Validate manifests against Kubernetes schemas using kubeconform or kubeval
- Use Helm unit tests (helm-unittest) to verify template rendering
- Run policy checks with OPA/Gatekeeper, Kyverno, or Datree in CI
- Test Helm values across environments (dev, staging, prod) to catch drift
- Use `helm template` to render and inspect output before installing
- Test deployments in ephemeral namespaces or Kind/k3d clusters in CI
- Validate CRDs and custom resources against their schemas

## Example

```bash
# Validate manifests against schemas
kubeconform -strict -kubernetes-version 1.29.0 k8s/

# Render and validate Helm chart
helm template my-release ./chart -f values-prod.yaml | kubeconform -strict

# Lint Helm chart
helm lint ./chart -f values.yaml

# Run Helm unit tests
helm unittest ./chart
```

```yaml
# tests/deployment_test.yaml (helm-unittest)
suite: deployment tests
templates:
  - deployment.yaml
tests:
  - it: should set resource limits
    asserts:
      - isNotNull:
          path: spec.template.spec.containers[0].resources.limits.memory
      - isNotNull:
          path: spec.template.spec.containers[0].resources.limits.cpu

  - it: should run as non-root
    asserts:
      - equal:
          path: spec.template.spec.containers[0].securityContext.runAsNonRoot
          value: true
```
