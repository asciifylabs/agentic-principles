# Use Package.json Scripts for Tasks

> Define all development, build, and deployment tasks as npm scripts in package.json.

## Rules

- Use npm scripts instead of shell scripts or Makefiles for project tasks
- Define scripts for common tasks: `start`, `dev`, `build`, `test`, `lint`, `format`
- Use `pre` and `post` hooks for setup and cleanup tasks
- Use tools like `npm-run-all` or `concurrently` for running multiple scripts
- Document all scripts in README.md
- Avoid complex logic in scripts -- extract to separate files if needed
- Use cross-platform commands or packages like `cross-env` for compatibility

## Example

```json
{
  "scripts": {
    "start": "node dist/index.js",
    "dev": "nodemon src/index.js",
    "build": "tsc",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "lint": "eslint src",
    "lint:fix": "eslint src --fix",
    "format": "prettier --write \"src/**/*.{js,ts}\"",
    "precommit": "npm run lint && npm run test",
    "prebuild": "npm run lint",
    "typecheck": "tsc --noEmit",
    "clean": "rm -rf dist",
    "prepublishOnly": "npm run build"
  }
}
```
