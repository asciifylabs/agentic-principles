# Use Structured Logging

> Implement structured logging with log levels and context instead of console.log statements.

## Rules

- Use a logging library like `pino`, `winston`, or `bunyan` instead of `console.log`
- Include log levels (debug, info, warn, error, fatal) and use them appropriately
- Log structured data (JSON) for easy parsing and searching
- Include contextual information (request ID, user ID, timestamp, etc.)
- Configure different log levels for different environments (verbose in dev, concise in prod)
- Never log sensitive information (passwords, tokens, PII)
- Use log aggregation tools in production (CloudWatch, DataDog, ELK stack)
- Remove or disable debug logs in production

## Example

```javascript
// Bad: unstructured console logging
console.log('User logged in');
console.log('Error:', error);

// Good: structured logging with pino
import pino from 'pino';

const logger = pino({
  level: process.env.LOG_LEVEL || 'info',
  transport: process.env.NODE_ENV === 'development'
    ? { target: 'pino-pretty' }
    : undefined
});

// Log with context
logger.info({ userId: user.id, email: user.email }, 'User logged in');

// Log errors with full context
logger.error(
  {
    err: error,
    userId: user.id,
    operation: 'fetchUserData',
    requestId: req.id
  },
  'Failed to fetch user data'
);

// Child loggers for request context
app.use((req, res, next) => {
  req.log = logger.child({ requestId: req.id });
  next();
});
```
