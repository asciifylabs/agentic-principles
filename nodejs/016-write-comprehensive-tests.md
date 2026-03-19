# Write Comprehensive Tests

> Use a layered testing strategy with unit, integration, and end-to-end tests to ensure correctness and prevent regressions.

## Rules

- Use a modern test runner (Vitest, Jest, or Node.js built-in test runner)
- Write unit tests for business logic, pure functions, and utilities
- Write integration tests for API endpoints, database queries, and external service interactions
- Use test fixtures and factories instead of hardcoded test data
- Mock external dependencies at service boundaries, not internal modules
- Aim for meaningful coverage of critical paths, not arbitrary coverage percentages
- Run tests in CI on every PR; block merges on test failure

## Example

```typescript
// Bad: no tests, or testing implementation details
test("calls database", () => {
  const spy = jest.spyOn(db, "query");
  getUser(1);
  expect(spy).toHaveBeenCalledWith("SELECT * FROM users WHERE id = $1", [1]);
});

// Good: test behavior, not implementation
import { describe, it, expect, beforeEach } from "vitest";
import { createApp } from "../src/app.js";
import { createTestDatabase } from "./helpers/db.js";

describe("GET /users/:id", () => {
  let app: Express;
  let db: TestDatabase;

  beforeEach(async () => {
    db = await createTestDatabase();
    app = createApp({ db });
  });

  it("returns the user when found", async () => {
    await db.seed({ users: [{ id: 1, name: "Alice" }] });

    const response = await request(app).get("/users/1");

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ id: 1, name: "Alice" });
  });

  it("returns 404 for unknown user", async () => {
    const response = await request(app).get("/users/999");
    expect(response.status).toBe(404);
  });
});
```

```bash
# Run tests with coverage
npx vitest run --coverage

# Run tests in watch mode during development
npx vitest
```
