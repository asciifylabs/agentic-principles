# Use Proper Error Handling

> Implement comprehensive error handling with meaningful error messages and proper error propagation.

## Rules

- Always wrap async operations in try/catch blocks
- Use custom error classes for domain-specific errors
- Include contextual information in error messages (what failed, why, where)
- Log errors with appropriate severity levels before re-throwing
- Never swallow errors silently with empty catch blocks
- Handle unhandled promise rejections and uncaught exceptions at process level
- Use error middleware in Express/HTTP frameworks
- Distinguish between operational errors (expected) and programmer errors (bugs)

## Example

```javascript
// Bad: swallowing errors
async function getUser(id) {
  try {
    return await db.users.findById(id);
  } catch (error) {
    return null; // Error lost!
  }
}

// Good: proper error handling
class UserNotFoundError extends Error {
  constructor(userId) {
    super(`User not found: ${userId}`);
    this.name = 'UserNotFoundError';
    this.userId = userId;
  }
}

async function getUser(id) {
  try {
    const user = await db.users.findById(id);
    if (!user) {
      throw new UserNotFoundError(id);
    }
    return user;
  } catch (error) {
    logger.error('Failed to get user', { userId: id, error });
    throw error;
  }
}

// Process-level handlers
process.on('unhandledRejection', (error) => {
  logger.fatal('Unhandled rejection', { error });
  process.exit(1);
});
```
