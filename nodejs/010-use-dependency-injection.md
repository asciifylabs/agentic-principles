# Use Dependency Injection for Testability

> Pass dependencies as parameters instead of hardcoding them to improve testability and maintainability.

## Rules

- Inject dependencies through function parameters or constructors
- Avoid direct imports of modules that have side effects or external dependencies
- Use dependency injection for database connections, external services, and configuration
- Create factory functions or use DI containers for complex dependency graphs
- Make dependencies explicit in function signatures
- Use interfaces or types to define contracts between modules
- Inject mocks and stubs in tests instead of using complex mocking libraries

## Example

```javascript
// Bad: hardcoded dependencies
import { db } from './database.js';
import { emailService } from './email.js';

export async function createUser(userData) {
  const user = await db.users.create(userData);
  await emailService.sendWelcome(user.email);
  return user;
}

// Good: dependency injection
export function createUserService(db, emailService) {
  return {
    async createUser(userData) {
      const user = await db.users.create(userData);
      await emailService.sendWelcome(user.email);
      return user;
    }
  };
}

// Usage in application
import { db } from './database.js';
import { emailService } from './email.js';

const userService = createUserService(db, emailService);
await userService.createUser(userData);

// Easy to test with mocks
const mockDb = { users: { create: jest.fn() } };
const mockEmail = { sendWelcome: jest.fn() };
const testService = createUserService(mockDb, mockEmail);
```
