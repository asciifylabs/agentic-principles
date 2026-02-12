# Use Structured Logging

> Use the `logging` module with structured formats instead of print statements for observable, debuggable production systems.

## Rules

- Never use `print()` for logging; use the `logging` module instead
- Configure logging at application entry point with appropriate levels and formats
- Use structured logging with context fields (JSON format) for production systems
- Include logger names using `__name__` to identify source of log messages
- Use appropriate log levels: DEBUG, INFO, WARNING, ERROR, CRITICAL
- Add contextual information using extra parameters or structured loggers
- Configure separate handlers for different outputs (console, file, external services)

## Example

```python
# Bad: using print statements
def process_order(order_id):
    print(f"Processing order {order_id}")
    try:
        result = charge_payment(order_id)
        print(f"Payment successful: {result}")
    except Exception as e:
        print(f"ERROR: {e}")

# Good: structured logging
import logging
from pythonjsonlogger import jsonlogger

logger = logging.getLogger(__name__)

def configure_logging():
    """Configure structured JSON logging."""
    handler = logging.StreamHandler()
    formatter = jsonlogger.JsonFormatter(
        "%(asctime)s %(name)s %(levelname)s %(message)s"
    )
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    logger.setLevel(logging.INFO)

def process_order(order_id: str) -> None:
    """Process customer order."""
    logger.info("Processing order", extra={
        "order_id": order_id,
        "action": "process_start"
    })
    try:
        result = charge_payment(order_id)
        logger.info("Payment successful", extra={
            "order_id": order_id,
            "amount": result.amount,
            "transaction_id": result.transaction_id
        })
    except PaymentError as e:
        logger.error("Payment failed", extra={
            "order_id": order_id,
            "error": str(e)
        }, exc_info=True)
        raise
```
