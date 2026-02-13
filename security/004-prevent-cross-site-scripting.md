# Prevent Cross-Site Scripting (XSS)

> Encode all dynamic output and enforce Content Security Policy to prevent malicious script execution in browsers.

## Rules

- Always HTML-encode user-supplied data before rendering it in HTML context
- Use your framework's built-in auto-escaping (React JSX, Django templates, Go html/template) — do not bypass it
- Never use `innerHTML`, `dangerouslySetInnerHTML`, `document.write()`, or `v-html` with untrusted content
- Implement Content Security Policy (CSP) headers that restrict script sources — avoid `unsafe-inline` and `unsafe-eval`
- Use context-aware encoding: HTML-encode for HTML body, attribute-encode for HTML attributes, JS-encode for JavaScript contexts, URL-encode for URLs
- Sanitize rich-text input with a strict allowlist library (DOMPurify, bleach) — never with regex
- Set `HttpOnly` and `Secure` flags on cookies to prevent JavaScript access
- Validate URLs before rendering them as `href` or `src` — block `javascript:` and `data:` protocols
- Apply output encoding on the server side, not just the client side

## Example

```jsx
// React: safe by default (auto-escapes)
function UserGreeting({ name }) {
  return <h1>Hello, {name}</h1>; // Escaped automatically
}

// Bad: bypasses React's escaping
function UnsafeGreeting({ html }) {
  return <div dangerouslySetInnerHTML={{ __html: html }} />; // XSS risk
}

// Good: sanitize if you must render HTML
import DOMPurify from "dompurify";

function SafeHtmlRenderer({ html }) {
  const clean = DOMPurify.sanitize(html);
  return <div dangerouslySetInnerHTML={{ __html: clean }} />;
}
```

```http
# Good: Content Security Policy header
Content-Security-Policy: default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self' data:; object-src 'none';
```
