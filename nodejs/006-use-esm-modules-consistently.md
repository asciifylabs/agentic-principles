# Use ESM Modules Consistently

> Use ECMAScript Modules (ESM) with import/export syntax consistently throughout your project.

## Rules

- Use ESM (import/export) for new projects unless you have a specific reason to use CommonJS
- Add `"type": "module"` to package.json for ESM
- Use `.mjs` extension for ESM files if not setting type in package.json
- Never mix ESM and CommonJS in the same project
- Use named exports for multiple exports, default export for single primary export
- Import packages using their documented module format
- Use `import.meta.url` instead of `__dirname` in ESM modules
- Use dynamic `import()` for conditional or lazy loading

## Example

```json
// package.json
{
  "type": "module"
}
```

```javascript
// Bad: mixing CommonJS and ESM
const express = require('express');
import { readFile } from 'fs/promises';

// Good: consistent ESM
import express from 'express';
import { readFile } from 'fs/promises';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

// ESM equivalent of __dirname
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Named exports
export const helper = () => {};
export const config = {};

// Default export for main export
export default function main() {}
```
