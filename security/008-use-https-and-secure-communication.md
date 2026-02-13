# Use HTTPS and Secure Communication

> Encrypt all data in transit with TLS — enforce HTTPS, validate certificates, and eliminate mixed content.

## Rules

- Use HTTPS for all traffic in production — never serve sensitive data over plain HTTP
- Enable HTTP Strict Transport Security (HSTS) with a minimum `max-age` of one year and `includeSubDomains`
- Redirect all HTTP requests to HTTPS at the server or load balancer level
- Use TLS 1.2 or higher — disable TLS 1.0, TLS 1.1, and all SSL versions
- Validate TLS certificates in all outbound requests — never disable certificate verification in production
- Eliminate mixed content: ensure all resources (scripts, styles, images, APIs) are loaded over HTTPS
- Use strong cipher suites and disable weak ones (RC4, DES, 3DES, export ciphers)
- Pin certificates or use Certificate Transparency for critical services
- Encrypt internal service-to-service communication — do not assume the internal network is trusted
- Use secure WebSocket connections (`wss://`) instead of unencrypted (`ws://`)

## Example

```javascript
// Good: enforce HTTPS in Express
import helmet from "helmet";

app.use(
  helmet.hsts({
    maxAge: 31536000, // 1 year in seconds
    includeSubDomains: true,
    preload: true,
  })
);

// Redirect HTTP to HTTPS
app.use((req, res, next) => {
  if (req.header("x-forwarded-proto") !== "https") {
    return res.redirect(301, `https://${req.hostname}${req.url}`);
  }
  next();
});
```

```python
# Bad: disabling certificate verification
requests.get("https://api.example.com", verify=False)  # NEVER do this

# Good: proper TLS verification (default behavior)
requests.get("https://api.example.com")  # verify=True by default
```
