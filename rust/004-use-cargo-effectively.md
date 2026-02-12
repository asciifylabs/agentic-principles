# Use Cargo Effectively

> Leverage Cargo for dependency management, building, testing, and publishing Rust projects.

## Rules

- Use `Cargo.toml` for all project configuration and dependencies
- Pin dependencies with version constraints (semantic versioning)
- Use workspaces for multi-crate projects
- Run `cargo clippy` for linting and `cargo fmt` for formatting
- Use `cargo build --release` for optimized production builds
- Lock dependencies with `Cargo.lock` (commit for binaries, ignore for libraries)
- Use feature flags to make dependencies optional

## Example

**Cargo.toml:**

```toml
[package]
name = "myapp"
version = "0.1.0"
edition = "2021"
authors = ["Your Name <you@example.com>"]

[dependencies]
# Semantic versioning constraints
serde = { version = "1.0", features = ["derive"] }
tokio = { version = "1.35", features = ["full"] }
reqwest = "0.11"

[dev-dependencies]
# Development/test-only dependencies
mockall = "0.12"

[build-dependencies]
# Build script dependencies
cc = "1.0"

[features]
default = ["json"]
json = ["serde_json"]
xml = ["quick-xml"]

[[bin]]
name = "myapp"
path = "src/main.rs"

[profile.release]
opt-level = 3
lto = true
codegen-units = 1
```

**Common Cargo commands:**

```bash
# Create new project
cargo new myapp
cargo new --lib mylib

# Build project
cargo build              # Debug build
cargo build --release    # Optimized build

# Run project
cargo run
cargo run --release

# Test project
cargo test              # Run all tests
cargo test test_name    # Run specific test

# Lint and format
cargo clippy            # Lint
cargo fmt               # Format code

# Update dependencies
cargo update

# Check without building
cargo check             # Fast syntax check

# Build documentation
cargo doc --open

# Publish to crates.io
cargo publish
```

**Workspace setup (Cargo.toml in root):**

```toml
[workspace]
members = [
    "crates/core",
    "crates/api",
    "crates/cli",
]

[workspace.dependencies]
# Shared dependency versions
tokio = { version = "1.35", features = ["full"] }
serde = { version = "1.0", features = ["derive"] }
```

**Using workspace dependencies:**

```toml
# crates/core/Cargo.toml
[package]
name = "myapp-core"
version = "0.1.0"
edition = "2021"

[dependencies]
tokio = { workspace = true }
serde = { workspace = true }

# Internal dependency
myapp-api = { path = "../api" }
```

**Feature flags:**

```rust
// src/lib.rs
#[cfg(feature = "json")]
pub mod json_handler;

#[cfg(feature = "xml")]
pub mod xml_handler;

// Build with features
// cargo build --features json
// cargo build --features "json,xml"
```
