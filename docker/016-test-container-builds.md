# Test Container Builds

> Validate container images build correctly, run as expected, and meet security requirements before deployment.

## Rules

- Use container-structure-test or similar tools to validate image contents
- Test that the application starts and responds to health checks inside the container
- Verify the container runs as the expected non-root user
- Test that no secrets or unnecessary files are included in the final image
- Run integration tests against the containerized application in CI/CD
- Test multi-platform builds (amd64, arm64) when targeting multiple architectures
- Include smoke tests in docker-compose test profiles

## Example

```yaml
# container-structure-test config
schemaVersion: "2.0.0"
metadataTest:
  user: "appuser"
  exposedPorts: ["8080"]
  entrypoint: ["/app/server"]

fileExistenceTests:
  - name: "App binary exists"
    path: "/app/server"
    shouldExist: true
    permissions: "-rwxr-xr-x"
  - name: "No secrets in image"
    path: "/app/.env"
    shouldExist: false

commandTests:
  - name: "App responds to health check"
    command: "/app/server"
    args: ["--health-check"]
    expectedOutput: ["ok"]
    exitCode: 0
```

```bash
# Run structure tests
container-structure-test test \
  --image myapp:latest \
  --config container-structure-test.yaml

# Smoke test with docker-compose
docker compose -f docker-compose.test.yml up --abort-on-container-exit
```
