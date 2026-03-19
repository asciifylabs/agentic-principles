# Test with Molecule

> Use Molecule to test Ansible roles in isolated environments before deploying to real infrastructure.

## Rules

- Write Molecule tests for every role
- Test idempotency by running the converge step twice and checking for changes
- Use Docker or Podman as the default driver for fast feedback loops
- Include verify steps using Ansible assertions or Testinfra
- Run Molecule tests in CI/CD pipelines to catch regressions
- Test against multiple OS families (Debian, RHEL) when roles support them
- Use `molecule test` for full lifecycle: create, converge, idempotence, verify, destroy

## Example

```bash
# Initialize Molecule scenario for a role
cd roles/nginx
molecule init scenario --driver-name docker

# Run full test lifecycle
molecule test

# Run only converge + verify for faster iteration
molecule converge && molecule verify
```

```yaml
# molecule/default/molecule.yml
driver:
  name: docker
platforms:
  - name: ubuntu
    image: ubuntu:22.04
    pre_build_image: true
  - name: rocky
    image: rockylinux:9
    pre_build_image: true
provisioner:
  name: ansible
verifier:
  name: ansible

# molecule/default/verify.yml
- name: Verify nginx is running
  hosts: all
  tasks:
    - name: Check nginx service
      ansible.builtin.service_facts:

    - name: Assert nginx is running
      ansible.builtin.assert:
        that:
          - "'nginx.service' in services"
          - "services['nginx.service'].state == 'running'"
```
