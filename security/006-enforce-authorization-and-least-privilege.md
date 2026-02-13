# Enforce Authorization and Least Privilege

> Verify permissions on every request, deny by default, and grant only the minimum access required for each operation.

## Rules

- Check authorization on every request server-side — never rely on client-side checks or hidden UI elements for access control
- Deny by default: if no explicit permission grants access, the request must be rejected
- Implement role-based (RBAC) or attribute-based (ABAC) access control with clearly defined roles and permissions
- Verify resource ownership — ensure users can only access their own resources unless explicitly authorized for others
- Apply the principle of least privilege: grant the minimum permissions needed for each role, service, or process
- Use middleware or decorators to enforce authorization consistently across all routes — avoid per-endpoint ad-hoc checks
- Separate authentication (who are you?) from authorization (what can you do?) — do not conflate them
- Re-check permissions for state-changing operations, even if the user passed a read check
- API keys and service accounts must have scoped permissions — never use a "god" key with full access
- Log all authorization failures for security monitoring and audit

## Example

```python
# Good: decorator-based authorization
from functools import wraps

def require_role(*allowed_roles):
    def decorator(func):
        @wraps(func)
        def wrapper(request, *args, **kwargs):
            if request.user.role not in allowed_roles:
                raise PermissionDenied("Insufficient permissions")
            return func(request, *args, **kwargs)
        return wrapper
    return decorator

@require_role("admin", "manager")
def delete_user(request, user_id):
    # Only admins and managers reach this point
    ...
```

```typescript
// Good: resource ownership check
async function getDocument(userId: string, docId: string) {
  const doc = await db.documents.findById(docId);
  if (!doc) throw new NotFoundError("Document not found");
  if (doc.ownerId !== userId && !hasRole(userId, "admin")) {
    throw new ForbiddenError("Access denied");
  }
  return doc;
}
```
