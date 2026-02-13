# Implement Authentication Properly

> Use established authentication libraries and proven patterns — never build custom password hashing, token generation, or session management from scratch.

## Rules

- Use established authentication libraries and frameworks (Passport.js, NextAuth, Django auth, Spring Security) — do not roll your own
- Hash passwords with bcrypt, argon2, or scrypt — never use MD5, SHA-1, SHA-256, or any unsalted hash for passwords
- Use a minimum cost factor of 10 for bcrypt (12+ recommended) and tune for ~250ms hash time
- Generate session tokens and API keys with cryptographically secure random generators (`crypto.randomBytes`, `secrets.token_urlsafe`, `crypto/rand`)
- Implement account lockout or exponential backoff after repeated failed login attempts
- Support multi-factor authentication (MFA/2FA) for sensitive operations and admin accounts
- Set session expiration and implement idle timeout — force re-authentication for sensitive actions
- Use secure, `HttpOnly`, `SameSite=Strict` cookies for session storage — avoid localStorage for auth tokens
- Invalidate all sessions on password change
- Never reveal whether a username or email exists in login error messages — use generic messages like "Invalid credentials"
- Log all authentication events (success, failure, lockout) for audit purposes

## Example

```python
# Good: bcrypt password hashing
import bcrypt

def hash_password(password: str) -> str:
    return bcrypt.hashpw(password.encode(), bcrypt.gensalt(rounds=12)).decode()

def verify_password(password: str, hashed: str) -> bool:
    return bcrypt.checkpw(password.encode(), hashed.encode())
```

```javascript
// Good: secure session configuration
app.use(
  session({
    secret: process.env.SESSION_SECRET,
    name: "__session", // non-default name
    resave: false,
    saveUninitialized: false,
    cookie: {
      secure: true, // HTTPS only
      httpOnly: true, // No JavaScript access
      sameSite: "strict", // CSRF protection
      maxAge: 3600000, // 1 hour
    },
  })
);
```
