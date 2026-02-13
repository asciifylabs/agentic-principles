# Protect Against CSRF

> Use anti-CSRF tokens, SameSite cookies, and origin validation to prevent cross-site request forgery attacks on state-changing operations.

## Rules

- Include a unique, unpredictable CSRF token in every state-changing form and AJAX request
- Validate the CSRF token server-side on every POST, PUT, PATCH, and DELETE request
- Use your framework's built-in CSRF protection (Django CSRF middleware, Express csurf, Spring Security CSRF) — do not build your own
- Set `SameSite=Strict` or `SameSite=Lax` on all session cookies to prevent cross-origin cookie sending
- Verify the `Origin` and `Referer` headers on state-changing requests as a defense-in-depth measure
- Never use GET requests for state-changing operations — GET must be safe and idempotent
- For API-only applications using token-based auth (Bearer tokens), ensure tokens are sent via headers, not cookies
- Regenerate CSRF tokens after login to prevent token fixation

## Example

```html
<!-- Good: CSRF token in form (Django) -->
<form method="POST" action="/transfer">
  {% csrf_token %}
  <input name="amount" type="number" />
  <input name="recipient" type="text" />
  <button type="submit">Transfer</button>
</form>
```

```javascript
// Good: CSRF token in AJAX request
fetch("/api/transfer", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
    "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
  },
  body: JSON.stringify({ amount: 100, recipient: "user@example.com" }),
});
```
