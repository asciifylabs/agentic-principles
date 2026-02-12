# Use Async/Await Over Callbacks

> Prefer async/await syntax over callbacks and raw promises for cleaner, more maintainable asynchronous code.

## Rules

- Always use async/await for asynchronous operations instead of callbacks
- Avoid callback hell by converting callback-based APIs to promises using `util.promisify()`
- Chain promises only when necessary; prefer async/await for sequential operations
- Use `Promise.all()` or `Promise.allSettled()` for concurrent operations
- Always handle promise rejections with try/catch blocks in async functions
- Never mix callback and promise patterns in the same codebase

## Example

```javascript
// Bad: callback hell
fs.readFile('file.txt', (err, data) => {
  if (err) return handleError(err);
  processData(data, (err, result) => {
    if (err) return handleError(err);
    saveResult(result, (err) => {
      if (err) return handleError(err);
    });
  });
});

// Good: async/await
async function processFile() {
  try {
    const data = await fs.promises.readFile('file.txt');
    const result = await processData(data);
    await saveResult(result);
  } catch (error) {
    handleError(error);
  }
}
```
