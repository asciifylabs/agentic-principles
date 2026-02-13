# Log Security Events

> Record all authentication, authorization, and security-relevant events with structured logging — enable detection, investigation, and compliance auditing.

## Rules

- Log all authentication events: successful logins, failed logins, logouts, password changes, MFA enrollment/usage
- Log all authorization failures: access denied events with the user, resource, and attempted action
- Log account lifecycle events: creation, deletion, role changes, permission grants/revokes
- Log security-sensitive operations: data exports, bulk deletions, configuration changes, API key creation
- Never log secrets, passwords, tokens, API keys, credit card numbers, or other sensitive values
- Mask or truncate personally identifiable information (PII) in logs — log only what is necessary for investigation
- Use structured logging (JSON) with consistent fields: timestamp, event type, user ID, IP address, request ID, outcome
- Include sufficient context for investigation: what happened, who did it, when, from where, and the outcome
- Forward security logs to a centralized logging system (SIEM) with tamper-proof storage
- Set appropriate log retention periods for compliance requirements (typically 90 days to 7 years)
- Alert on anomalous patterns: brute force attempts, privilege escalation, unusual access patterns

## Example

```python
# Good: structured security event logging
import structlog

security_logger = structlog.get_logger("security")

def login(request):
    user = authenticate(request.email, request.password)
    if user:
        security_logger.info(
            "authentication.success",
            user_id=user.id,
            ip_address=request.remote_addr,
            user_agent=request.user_agent,
        )
    else:
        security_logger.warning(
            "authentication.failure",
            email=request.email,  # OK to log email, NOT the password
            ip_address=request.remote_addr,
            reason="invalid_credentials",
        )
```

```json
// Example structured security log entry
{
  "timestamp": "2024-01-15T14:30:00Z",
  "level": "warning",
  "event": "authorization.denied",
  "user_id": "usr_abc123",
  "resource": "/api/admin/users",
  "action": "DELETE",
  "ip_address": "192.168.1.100",
  "request_id": "req_xyz789",
  "reason": "insufficient_permissions"
}
```
