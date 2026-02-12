# Use Graceful Shutdown

> Implement graceful shutdown to properly close connections and finish processing before terminating the application.

## Rules

- Listen for `SIGTERM` and `SIGINT` signals to initiate shutdown
- Stop accepting new requests when shutdown is initiated
- Allow in-flight requests to complete within a timeout period
- Close database connections, message queues, and other resources properly
- Use a shutdown timeout to force exit if graceful shutdown takes too long
- Log shutdown events for observability
- Respond with `503 Service Unavailable` to health checks during shutdown
- Use packages like `terminus` for Express or implement manually

## Example

```javascript
// Good: graceful shutdown implementation
import express from 'express';
import { createTerminus } from '@godaddy/terminus';

const app = express();
const server = app.listen(3000);

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// Cleanup function
async function onShutdown() {
  logger.info('Starting graceful shutdown');

  // Close database connections
  await db.close();

  // Close message queue connections
  await messageQueue.disconnect();

  // Any other cleanup
  logger.info('Graceful shutdown completed');
}

// Setup graceful shutdown
createTerminus(server, {
  timeout: 10000, // 10 seconds
  signals: ['SIGTERM', 'SIGINT'],
  beforeShutdown: async () => {
    // Give load balancer time to deregister
    await new Promise(resolve => setTimeout(resolve, 5000));
  },
  onShutdown,
  logger: (msg, err) => logger.error({ err }, msg)
});

// Manual implementation alternative
process.on('SIGTERM', async () => {
  logger.info('SIGTERM received');
  server.close(async () => {
    await onShutdown();
    process.exit(0);
  });

  // Force shutdown after timeout
  setTimeout(() => {
    logger.error('Forced shutdown after timeout');
    process.exit(1);
  }, 10000);
});
```
