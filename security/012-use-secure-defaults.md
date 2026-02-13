# Use Secure Defaults

> Configure applications to be secure out of the box — disable debug features in production, restrict CORS, minimize exposed surface area, and require explicit opt-in for risky settings.

## Rules

- Disable debug mode, verbose logging, and developer tools in production environments
- Use restrictive CORS policies — never use `Access-Control-Allow-Origin: *` in production with credentials
- Disable directory listing on web servers
- Remove default accounts, passwords, and sample data before deployment
- Set restrictive file permissions — follow the principle of least privilege for file system access
- Disable unnecessary HTTP methods (TRACE, OPTIONS where not needed)
- Configure security headers by default: `X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY`, `Referrer-Policy: strict-origin-when-cross-origin`
- Use parameterized configuration with environment-specific overrides — never embed production settings in code
- Disable unnecessary features and services — every enabled feature is an attack surface
- Default to denying access and requiring explicit grants rather than defaulting to open access
- Ensure error pages do not reveal framework or server version information

## Example

```python
# Good: Django production settings
DEBUG = False
ALLOWED_HOSTS = ["myapp.example.com"]
SECURE_SSL_REDIRECT = True
SECURE_HSTS_SECONDS = 31536000
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_CONTENT_TYPE_NOSNIFF = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
X_FRAME_OPTIONS = "DENY"
```

```javascript
// Good: restrictive CORS configuration
app.use(
  cors({
    origin: ["https://myapp.example.com"],
    methods: ["GET", "POST", "PUT", "DELETE"],
    allowedHeaders: ["Content-Type", "Authorization"],
    credentials: true,
    maxAge: 86400,
  })
);
```
