# Write Security-Focused Tests

> Test authentication boundaries, input rejection, error responses, and authorization rules explicitly — do not assume security works because the happy path passes.

## Rules

- Write tests that verify authentication is required: unauthenticated requests to protected endpoints must return 401
- Write tests that verify authorization: users must not access resources or actions beyond their role
- Test input validation: verify that malformed, oversized, and malicious inputs are rejected with appropriate error codes
- Test error responses: verify that error messages do not leak stack traces, internal paths, or system details
- Test rate limiting: verify that excessive requests are throttled and return 429
- Test CSRF protection: verify that state-changing requests without valid CSRF tokens are rejected
- Test authentication edge cases: expired tokens, revoked sessions, concurrent sessions, password changes invalidating sessions
- Include negative test cases for every security control — test that the control rejects what it should
- Use fuzz testing to discover unexpected input handling bugs in parsers and validators
- Test that sensitive data is not exposed in API responses, logs, or error messages
- Run security tests in CI — they must pass before merging

## Example

```python
# Good: security-focused test cases
class TestAuthSecurity:
    def test_unauthenticated_access_returns_401(self, client):
        response = client.get("/api/admin/users")
        assert response.status_code == 401

    def test_unauthorized_role_returns_403(self, client, user_token):
        response = client.delete(
            "/api/admin/users/123",
            headers={"Authorization": f"Bearer {user_token}"},
        )
        assert response.status_code == 403

    def test_expired_token_returns_401(self, client, expired_token):
        response = client.get(
            "/api/profile",
            headers={"Authorization": f"Bearer {expired_token}"},
        )
        assert response.status_code == 401

    def test_sql_injection_in_search_is_rejected(self, client, auth_headers):
        response = client.get(
            "/api/users?q=' OR 1=1 --",
            headers=auth_headers,
        )
        assert response.status_code == 400

    def test_error_response_does_not_leak_stack_trace(self, client, auth_headers):
        response = client.get("/api/trigger-error", headers=auth_headers)
        body = response.json()
        assert "traceback" not in str(body).lower()
        assert "stack" not in str(body).lower()
        assert "/home/" not in str(body)
        assert "/usr/" not in str(body)
```

```javascript
// Good: testing authorization boundaries
describe("Authorization", () => {
  it("prevents regular users from accessing admin endpoints", async () => {
    const res = await request(app)
      .delete("/api/admin/users/123")
      .set("Authorization", `Bearer ${userToken}`);
    expect(res.status).toBe(403);
  });

  it("prevents users from accessing other users' data", async () => {
    const res = await request(app)
      .get("/api/users/other-user-id/private")
      .set("Authorization", `Bearer ${userToken}`);
    expect(res.status).toBe(403);
  });
});
```
