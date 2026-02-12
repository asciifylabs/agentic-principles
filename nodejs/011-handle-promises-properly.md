# Handle Promises Properly

> Always handle promise rejections and avoid creating unhandled promise rejections.

## Rules

- Every promise must have a `.catch()` handler or be in a try/catch block
- Never create floating promises -- always await or explicitly handle them
- Use `Promise.allSettled()` when you need results from all promises regardless of failures
- Use `Promise.race()` for timeout patterns with `AbortController`
- Avoid creating promises unnecessarily with `new Promise()` when async/await suffices
- Handle errors in promise chains before they bubble up
- Use ESLint rule `no-floating-promises` to catch unhandled promises
- Be careful with `forEach` and other array methods -- they don't await promises

## Example

```javascript
// Bad: floating promise (unhandled)
async function bad() {
  saveToDatabase(data); // Promise not awaited or handled!
  return 'done';
}

// Bad: forEach doesn't await
users.forEach(async (user) => {
  await sendEmail(user); // Doesn't wait!
});

// Good: properly handled promises
async function good() {
  try {
    await saveToDatabase(data);
    return 'done';
  } catch (error) {
    logger.error({ error }, 'Failed to save to database');
    throw error;
  }
}

// Good: parallel processing with error handling
await Promise.allSettled(
  users.map(user => sendEmail(user))
);

// Good: for...of for sequential async operations
for (const user of users) {
  await sendEmail(user);
}

// Good: timeout pattern
const timeout = new Promise((_, reject) =>
  setTimeout(() => reject(new Error('Timeout')), 5000)
);
const result = await Promise.race([fetchData(), timeout]);
```
