# Handle Errors Without Leaking Information

> Return generic error messages to clients and log detailed diagnostics server-side — never expose stack traces, internal paths, or system details in responses.

## Rules

- Return generic, user-friendly error messages to clients (e.g., "Something went wrong") — never include stack traces, SQL errors, or internal paths
- Log full error details (stack trace, context, request ID) server-side for debugging
- Use a unique request/correlation ID in both the client response and server logs to enable tracing without exposing details
- Never reveal whether a specific record exists in error messages (e.g., "User not found" vs "Invalid credentials")
- Disable debug mode, verbose errors, and stack trace display in production environments
- Configure custom error pages for HTTP 4xx and 5xx responses — never use framework defaults in production
- Catch all unhandled exceptions with a global error handler that sanitizes output
- Never include database connection details, file system paths, or internal IP addresses in error responses
- Different error codes should not leak timing information — use constant-time comparison for sensitive checks

## Example

```typescript
// Good: global error handler that separates client vs server details
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  const requestId = crypto.randomUUID();

  // Log full details server-side
  logger.error({
    requestId,
    error: err.message,
    stack: err.stack,
    path: req.path,
    method: req.method,
    userId: req.user?.id,
  });

  // Return safe response to client
  res.status(err instanceof AppError ? err.statusCode : 500).json({
    error: err instanceof AppError ? err.message : "Internal server error",
    requestId, // enables support lookup without exposing details
  });
});
```

```python
# Bad: leaking stack trace to client
@app.errorhandler(500)
def handle_error(error):
    return str(error), 500  # Exposes internal details

# Good: generic message with server-side logging
@app.errorhandler(500)
def handle_error(error):
    request_id = uuid.uuid4().hex
    logger.error("Unhandled error", request_id=request_id, exc_info=error)
    return jsonify({"error": "Internal server error", "request_id": request_id}), 500
```
