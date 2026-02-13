# Implement Rate Limiting

> Apply rate limiting on authentication endpoints, APIs, and resource-intensive operations to prevent brute force attacks, abuse, and denial of service.

## Rules

- Rate-limit all authentication endpoints (login, registration, password reset, MFA verification) aggressively
- Implement API rate limiting per client (by API key, user ID, or IP address) with appropriate windows and limits
- Use HTTP 429 (Too Many Requests) responses with a `Retry-After` header to inform clients when they are throttled
- Apply progressive penalties: increase lockout duration after repeated violations (exponential backoff)
- Implement account lockout after a configurable number of failed login attempts (e.g., 5-10 attempts)
- Rate-limit resource-intensive operations: file uploads, report generation, bulk exports, search queries
- Use distributed rate limiting (Redis, memcached) in multi-instance deployments to prevent per-instance bypass
- Apply different rate limits for different tiers: stricter for anonymous users, more generous for authenticated users
- Rate-limit by multiple dimensions when appropriate: per IP, per user, per endpoint
- Monitor and alert on rate limit violations — they may indicate attack attempts
- Never rely solely on client-side throttling — always enforce server-side

## Example

```javascript
// Good: rate limiting with express-rate-limit
import rateLimit from "express-rate-limit";

// Strict limit for auth endpoints
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 10, // 10 attempts per window
  message: { error: "Too many attempts, please try again later" },
  standardHeaders: true, // Return rate limit info in headers
});
app.use("/api/auth/", authLimiter);

// General API limit
const apiLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 100,
  standardHeaders: true,
});
app.use("/api/", apiLimiter);
```

```python
# Good: rate limiting with Flask-Limiter
from flask_limiter import Limiter

limiter = Limiter(app, key_func=get_remote_address)

@app.route("/api/login", methods=["POST"])
@limiter.limit("10 per 15 minutes")
def login():
    ...

@app.route("/api/data")
@limiter.limit("100 per minute")
def get_data():
    ...
```
