# Use async/await for Concurrency

> Use async/await with an async runtime (Tokio, async-std) for efficient concurrent I/O operations.

## Rules

- Use `async fn` for asynchronous functions
- Use `.await` to wait for async operations
- Use Tokio or async-std as your async runtime
- Use `tokio::spawn` to run tasks concurrently
- Use `tokio::select!` for concurrent operations with cancellation
- Avoid blocking operations in async code; use `spawn_blocking` instead
- Use `async` blocks for inline asynchronous code

## Example

```rust
use tokio::time::{sleep, Duration};
use reqwest;

// Basic async function
async fn fetch_url(url: &str) -> Result<String, reqwest::Error> {
    let response = reqwest::get(url).await?;
    let body = response.text().await?;
    Ok(body)
}

// Async main with Tokio
#[tokio::main]
async fn main() {
    match fetch_url("https://example.com").await {
        Ok(body) => println!("Body length: {}", body.len()),
        Err(e) => eprintln!("Error: {}", e),
    }
}

// Concurrent tasks with spawn
async fn concurrent_fetches() {
    let handle1 = tokio::spawn(async {
        fetch_url("https://example.com").await
    });

    let handle2 = tokio::spawn(async {
        fetch_url("https://example.org").await
    });

    // Wait for both to complete
    let (result1, result2) = tokio::join!(handle1, handle2);

    println!("Results: {:?}, {:?}", result1, result2);
}

// Select for racing operations
use tokio::select;

async fn with_timeout() {
    select! {
        result = fetch_url("https://example.com") => {
            println!("Got result: {:?}", result);
        }
        _ = sleep(Duration::from_secs(5)) => {
            println!("Timeout!");
        }
    }
}

// Spawn multiple tasks
async fn process_urls(urls: Vec<String>) {
    let mut handles = vec![];

    for url in urls {
        let handle = tokio::spawn(async move {
            fetch_url(&url).await
        });
        handles.push(handle);
    }

    // Wait for all
    for handle in handles {
        match handle.await {
            Ok(Ok(body)) => println!("Success: {} bytes", body.len()),
            Ok(Err(e)) => eprintln!("Fetch error: {}", e),
            Err(e) => eprintln!("Task error: {}", e),
        }
    }
}

// Use spawn_blocking for CPU-intensive work
async fn cpu_intensive_task(data: Vec<u8>) -> Vec<u8> {
    tokio::task::spawn_blocking(move || {
        // Blocking/CPU-intensive operation
        expensive_computation(data)
    })
    .await
    .unwrap()
}

// Async blocks
async fn async_blocks() {
    let future = async {
        sleep(Duration::from_secs(1)).await;
        42
    };

    let result = future.await;
    println!("Result: {}", result);
}

// Async traits (requires async-trait crate)
use async_trait::async_trait;

#[async_trait]
trait AsyncRepository {
    async fn get_user(&self, id: u64) -> Result<User, Error>;
    async fn save_user(&self, user: &User) -> Result<(), Error>;
}

struct PostgresRepo {
    pool: sqlx::PgPool,
}

#[async_trait]
impl AsyncRepository for PostgresRepo {
    async fn get_user(&self, id: u64) -> Result<User, Error> {
        let user = sqlx::query_as!(
            User,
            "SELECT * FROM users WHERE id = $1",
            id as i64
        )
        .fetch_one(&self.pool)
        .await?;

        Ok(user)
    }

    async fn save_user(&self, user: &User) -> Result<(), Error> {
        sqlx::query!(
            "INSERT INTO users (name, email) VALUES ($1, $2)",
            user.name,
            user.email
        )
        .execute(&self.pool)
        .await?;

        Ok(())
    }
}

// Async iterators with streams
use tokio_stream::StreamExt;

async fn process_stream() {
    let mut stream = tokio_stream::iter(vec![1, 2, 3, 4, 5]);

    while let Some(value) = stream.next().await {
        println!("Got: {}", value);
    }
}

// Graceful shutdown
async fn server_with_shutdown() {
    let (tx, mut rx) = tokio::sync::oneshot::channel();

    let server_task = tokio::spawn(async move {
        loop {
            select! {
                _ = &mut rx => {
                    println!("Shutting down...");
                    break;
                }
                _ = handle_request() => {}
            }
        }
    });

    // Signal shutdown after some condition
    sleep(Duration::from_secs(10)).await;
    let _ = tx.send(());

    server_task.await.unwrap();
}
```

**Cargo.toml:**

```toml
[dependencies]
tokio = { version = "1", features = ["full"] }
reqwest = "0.11"
async-trait = "0.1"
tokio-stream = "0.1"
```
