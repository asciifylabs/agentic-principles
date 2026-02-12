# Organize Project Structure

> Use a clear, consistent directory structure that separates concerns and scales with project growth.

## Rules

- Organize code by feature or domain, not by file type
- Keep related files together (routes, controllers, services, tests in same feature folder)
- Use an `src/` directory for source code and `dist/` or `build/` for compiled output
- Place tests alongside the code they test or in a parallel `__tests__/` directory
- Use `index.js` or `index.ts` as the main entry point for each module
- Separate configuration, utilities, and shared code into dedicated directories
- Keep the root directory clean -- only essential files (package.json, README.md, etc.)
- Use path aliases to avoid deep relative imports (`../../../utils`)
- Document the structure in README.md

## Example

```
project/
├── src/
│   ├── index.ts                 # Application entry point
│   ├── config/                  # Configuration files
│   │   ├── database.ts
│   │   └── env.ts
│   ├── features/                # Feature-based organization
│   │   ├── users/
│   │   │   ├── user.routes.ts
│   │   │   ├── user.controller.ts
│   │   │   ├── user.service.ts
│   │   │   ├── user.model.ts
│   │   │   ├── user.schema.ts
│   │   │   └── user.test.ts
│   │   └── auth/
│   │       ├── auth.routes.ts
│   │       ├── auth.service.ts
│   │       └── auth.middleware.ts
│   ├── lib/                     # Shared utilities and helpers
│   │   ├── logger.ts
│   │   ├── errors.ts
│   │   └── validation.ts
│   └── types/                   # Shared TypeScript types
│       └── index.ts
├── tests/                       # Integration/E2E tests
│   └── integration/
├── dist/                        # Compiled output (gitignored)
├── package.json
├── tsconfig.json
└── README.md
```
