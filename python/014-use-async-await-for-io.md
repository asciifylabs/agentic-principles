# Use Async/Await for I/O Operations

> Use asyncio with async/await for I/O-bound operations to improve performance through concurrency without threading complexity.

## Rules

- Use `async def` for functions that perform I/O operations (network, file, database)
- Use `await` keyword to call other async functions
- Use `asyncio.gather()` to run multiple async operations concurrently
- Use async libraries: `aiohttp` for HTTP, `asyncpg` for PostgreSQL, `aiofiles` for files
- Never mix blocking (sync) and non-blocking (async) code without proper handling
- Use `asyncio.run()` as the entry point for async programs
- Use `asyncio.create_task()` to run tasks in the background
- Avoid CPU-bound work in async functions; use `run_in_executor()` or multiprocessing

## Example

```python
# Bad: synchronous I/O (slow, sequential)
import requests

def fetch_urls(urls):
    results = []
    for url in urls:
        response = requests.get(url)  # Blocks for each request
        results.append(response.json())
    return results

# Good: asynchronous I/O (fast, concurrent)
import asyncio
import aiohttp

async def fetch_url(session: aiohttp.ClientSession, url: str) -> dict:
    """Fetch a single URL asynchronously."""
    async with session.get(url) as response:
        return await response.json()

async def fetch_urls(urls: list[str]) -> list[dict]:
    """Fetch multiple URLs concurrently."""
    async with aiohttp.ClientSession() as session:
        tasks = [fetch_url(session, url) for url in urls]
        results = await asyncio.gather(*tasks)
        return results

# Entry point
if __name__ == "__main__":
    urls = ["https://api.example.com/1", "https://api.example.com/2"]
    results = asyncio.run(fetch_urls(urls))

# Good: background tasks
async def main():
    # Start background task
    task = asyncio.create_task(long_running_operation())

    # Do other work
    await do_something_else()

    # Wait for background task
    result = await task
```
