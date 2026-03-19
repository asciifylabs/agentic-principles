# Write Tests for Scripts

> Test shell scripts with a testing framework to catch regressions and verify behavior across edge cases.

## Rules

- Use a shell testing framework (bats-core, shunit2, or shellspec) for structured tests
- Test both success and failure paths, including edge cases and error conditions
- Test scripts with different input combinations and environment configurations
- Mock external commands when testing logic that depends on them
- Run tests in CI on every change to shell scripts
- Test exit codes, stdout, and stderr separately
- Keep test scripts alongside the code they test

## Example

```bash
# test/deploy.bats (using bats-core)
#!/usr/bin/env bats

setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
    export TEST_DIR="$(mktemp -d)"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "deploy.sh fails without required environment variable" {
    unset DEPLOY_TARGET
    run ./deploy.sh
    assert_failure
    assert_output --partial "DEPLOY_TARGET is required"
}

@test "deploy.sh validates target environment" {
    export DEPLOY_TARGET="invalid"
    run ./deploy.sh
    assert_failure
    assert_output --partial "must be one of: staging, production"
}

@test "deploy.sh succeeds with valid configuration" {
    export DEPLOY_TARGET="staging"
    export DRY_RUN=true
    run ./deploy.sh
    assert_success
    assert_output --partial "Deploying to staging"
}
```

```bash
# Run bats tests
bats test/

# Run with TAP output for CI
bats --formatter tap test/
```
