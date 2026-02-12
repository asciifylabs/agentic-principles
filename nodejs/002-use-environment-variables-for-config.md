# Use Environment Variables for Configuration

> Store all configuration, secrets, and environment-specific values in environment variables, never hardcode them.

## Rules

- Use environment variables for all configuration (ports, URLs, credentials, feature flags)
- Load environment variables using `dotenv` package in development
- Never commit `.env` files to version control -- add to `.gitignore`
- Provide a `.env.example` file documenting all required environment variables
- Validate required environment variables at application startup
- Use strict typing for environment variables with tools like `envalid` or Zod
- Fail fast if required environment variables are missing

## Example

```javascript
// Bad: hardcoded configuration
const config = {
  port: 3000,
  dbUrl: 'mongodb://localhost:27017/myapp',
  apiKey: 'sk-abc123xyz'
};

// Good: environment-based configuration
import dotenv from 'dotenv';
dotenv.config();

const config = {
  port: process.env.PORT || 3000,
  dbUrl: process.env.DATABASE_URL,
  apiKey: process.env.API_KEY
};

// Validate at startup
if (!config.dbUrl || !config.apiKey) {
  throw new Error('Missing required environment variables');
}
```
