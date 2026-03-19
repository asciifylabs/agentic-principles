# Write Meaningful PR Descriptions

> Every pull request should clearly explain what changed, why, and how to verify it.

## Rules

- Include a summary of what the PR does and the motivation behind it
- Link to relevant issues, tickets, or discussions
- Describe how to test or verify the changes
- Call out any breaking changes, migrations, or deployment steps
- Keep PRs focused and small; split large changes into stacked PRs
- Use PR templates to ensure consistent information across the team
- Add screenshots or recordings for UI changes

## Example

```markdown
## Summary
- Add rate limiting middleware to the API gateway
- Fixes #142 (API abuse from unauthenticated clients)

## Changes
- New `RateLimiter` middleware using token bucket algorithm
- Redis-backed counter for distributed rate tracking
- Returns 429 with Retry-After header when limit exceeded

## Test plan
- [ ] Unit tests for token bucket logic
- [ ] Integration test with Redis
- [ ] Load test confirming 429 responses above threshold
```
