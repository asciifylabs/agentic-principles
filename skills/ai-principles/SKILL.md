---
name: ai-principles
description: "AI application standards for LLM, RAG, agent, embedding, tool-calling, evaluation, guardrail, OpenAI, Anthropic, LangChain, PyTorch, or TensorFlow work."
license: MIT
paths: ["**/*.py", "**/*.ts", "**/*.tsx", "**/*.js", "**/*.jsx", "**/*.ipynb", "**/prompts/**/*.md", "**/evals/**/*.json", "**/evals/**/*.yaml"]
globs: ["**/*.py", "**/*.ts", "**/*.tsx", "**/*.js", "**/*.jsx", "**/*.ipynb", "**/prompts/**/*.md", "**/evals/**/*.json", "**/evals/**/*.yaml"]
metadata:
  asciify-source: asciify-skills
  asciify-category: ai
---

# AI Principles

Use this skill as standing guidance for this domain. Apply the checklist first; read the detailed reference only when the task is substantial, risky, unfamiliar, or review-oriented.

## Operating Rules

- Prefer the repository's existing conventions, toolchain, and CI commands over generic defaults.
- Make the smallest coherent change that satisfies the request while preserving behavior.
- Treat tests, linting, dependency hygiene, and security review as part of completion.
- If a principle conflicts with higher-priority repository instructions or an explicit user request, follow the higher-priority instruction and call out the tradeoff.

## Core Checklist

- Treat prompts, retrieved documents, tool outputs, and user uploads as untrusted data.
- Separate instructions from data with explicit boundaries and verify outputs before acting on them.
- Use structured outputs or schemas for data that drives code, tools, money movement, or permissions.
- Put hard limits around agent loops: tool allowlists, timeouts, step budgets, rate limits, and human approval for destructive actions.
- Evaluate with task-specific datasets, adversarial cases, regression tests, and production telemetry before changing prompts or models.
- Route models by measured quality, latency, and cost; keep model identifiers configurable.
- Design RAG around retrieval quality: chunk deliberately, cite sources where needed, detect stale or missing context, and handle no-answer cases.
- Log requests, model choices, tool calls, retrieval metadata, safety decisions, and failures without storing secrets or unnecessary personal data.
- Apply OWASP GenAI guidance for prompt injection, sensitive data exposure, supply-chain risk, and agentic autonomy.

## Validation

Run applicable checks when they exist in the project; if a tool is missing, report that it was skipped.

- Run the project's existing evals, prompt regression tests, and safety tests.
- Add or update eval cases for changed model behavior, retrieval behavior, tool calls, or guardrails.
- Inspect logs for token blowups, tool-loop failures, leaked secrets, and unsafe autonomous actions.

## Detailed Reference

For the complete principle set with examples and edge cases, read [references/principles.md](references/principles.md) when deeper guidance is useful.
