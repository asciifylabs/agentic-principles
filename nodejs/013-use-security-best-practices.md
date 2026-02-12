# Use Security Best Practices

> Implement security measures to protect against common vulnerabilities and attacks.

## Rules

- Use helmet.js middleware to set security HTTP headers in Express apps
- Implement rate limiting to prevent brute force and DoS attacks
- Validate and sanitize all inputs to prevent injection attacks
- Use parameterized queries or ORMs to prevent SQL injection
- Enable CORS with strict origin policies, not wildcard `*` in production
- Never expose sensitive data in error messages or stack traces to clients
- Use HTTPS in production (enforce with `express-force-ssl`)
- Implement authentication and authorization properly (use established libraries)
- Scan dependencies regularly with `npm audit` or `snyk`
- Use Content Security Policy (CSP) headers for web applications
- Hash and salt passwords with bcrypt or argon2, never store plain text
- Implement proper session management with secure, httpOnly cookies

## Example

```javascript
// Good: security middleware in Express
import express from 'express';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import cors from 'cors';

const app = express();

// Security headers
app.use(helmet());

// CORS with strict origin
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || 'https://example.com',
  credentials: true
}));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP'
});
app.use('/api/', limiter);

// Hide Express
app.disable('x-powered-by');

// Error handling - don't leak details
app.use((err, req, res, next) => {
  logger.error({ err, requestId: req.id });
  res.status(err.status || 500).json({
    error: process.env.NODE_ENV === 'production'
      ? 'Internal server error'
      : err.message
  });
});
```
