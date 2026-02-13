# Protect Sensitive Data

> Encrypt sensitive data at rest and in transit, mask PII in logs and outputs, classify data by sensitivity, and enforce retention policies.

## Rules

- Encrypt sensitive data at rest using strong algorithms (AES-256, ChaCha20) with proper key management
- Never store sensitive data in plain text: passwords, tokens, personal data, financial records, health records
- Classify data by sensitivity level (public, internal, confidential, restricted) and apply appropriate protections
- Mask or redact PII (emails, phone numbers, addresses, SSNs) in logs, error messages, and non-essential displays
- Use field-level encryption for highly sensitive database columns (credit cards, SSNs, health data)
- Implement data retention policies — automatically purge data that is no longer needed
- Minimize data collection — only collect and store what is strictly necessary for the business function
- Scrub sensitive data from development and staging environments — use anonymized or synthetic test data
- Implement secure deletion — overwrite or crypto-shred data rather than just marking it as deleted
- Comply with applicable data protection regulations (GDPR, CCPA, HIPAA, PCI-DSS) for data handling, storage, and transfer
- Never return more data than the client needs — use projection and field filtering in API responses

## Example

```python
# Good: mask PII in logs
def mask_email(email: str) -> str:
    local, domain = email.split("@")
    return f"{local[0]}{'*' * (len(local) - 1)}@{domain}"

def mask_card(card_number: str) -> str:
    return f"****-****-****-{card_number[-4:]}"

logger.info("Processing payment", email=mask_email(user.email), card=mask_card(card))
```

```typescript
// Good: selective API response fields
function toPublicUser(user: User): PublicUser {
  return {
    id: user.id,
    name: user.name,
    avatar: user.avatarUrl,
    // Excluded: email, phone, address, passwordHash, ssn
  };
}
```
