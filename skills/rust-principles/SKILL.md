---
name: rust-principles
description: "Rust engineering standards for .rs, Cargo.toml, Cargo.lock, tests, crates, error handling, async code, linting, or review."
license: MIT
paths: ["**/*.rs", "**/Cargo.toml", "**/Cargo.lock"]
globs: ["**/*.rs", "**/Cargo.toml", "**/Cargo.lock"]
metadata:
  asciify-source: asciify-skills
  asciify-category: rust
---

# Rust Principles

Use this skill as standing guidance for this domain. Apply the checklist first; read the detailed reference only when the task is substantial, risky, unfamiliar, or review-oriented.

## Operating Rules

- Prefer the repository's existing conventions, toolchain, and CI commands over generic defaults.
- Make the smallest coherent change that satisfies the request while preserving behavior.
- Treat tests, linting, dependency hygiene, and security review as part of completion.
- If a principle conflicts with higher-priority repository instructions or an explicit user request, follow the higher-priority instruction and call out the tradeoff.

## Core Checklist

- Model ownership and lifetimes directly instead of cloning or allocating around unclear design.
- Return `Result` and `Option` deliberately; do not use `unwrap`, `expect`, or `panic!` in production paths without justification.
- Define clear error types with context at API boundaries.
- Prefer iterators, pattern matching, traits, and newtypes when they improve clarity or safety.
- Keep unsafe code isolated, justified, documented, and covered by tests.
- Use async only where concurrency or I/O benefits justify it; avoid holding locks across `.await`.
- Keep crate features explicit and dependencies minimal.
- Run format, lint, tests, and dependency policy checks before release-sensitive changes.

## Validation

Run applicable checks when they exist in the project; if a tool is missing, report that it was skipped.

- `cargo fmt`
- `cargo clippy --all-targets --all-features -- -D warnings`
- `cargo test`
- `cargo audit` or `cargo deny check` for release-sensitive dependency changes

## Detailed Reference

For the complete principle set with examples and edge cases, read [references/principles.md](references/principles.md) when deeper guidance is useful.
