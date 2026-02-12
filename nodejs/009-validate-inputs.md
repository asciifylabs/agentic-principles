# Validate All Inputs

> Validate and sanitize all external inputs (API requests, user input, environment variables) at system boundaries.

## Rules

- Validate all incoming data at API boundaries using schema validation libraries
- Use tools like `joi`, `zod`, `yup`, or `ajv` for validation
- Validate types, formats, ranges, and required fields
- Return clear validation error messages to clients
- Never trust client-side validation alone
- Validate environment variables at application startup
- Sanitize inputs to prevent injection attacks (SQL, NoSQL, XSS)
- Use TypeScript for compile-time type checking in addition to runtime validation

## Example

```javascript
// Bad: no validation
app.post('/users', async (req, res) => {
  const user = await db.users.create(req.body); // Dangerous!
  res.json(user);
});

// Good: schema validation with zod
import { z } from 'zod';

const createUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1).max(100),
  age: z.number().int().min(18).max(120),
  role: z.enum(['user', 'admin']).default('user')
});

app.post('/users', async (req, res) => {
  try {
    const validatedData = createUserSchema.parse(req.body);
    const user = await db.users.create(validatedData);
    res.json(user);
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({
        error: 'Validation failed',
        details: error.errors
      });
    }
    throw error;
  }
});
```
