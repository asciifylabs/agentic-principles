# Use TypeScript for Type Safety

> Prefer TypeScript over JavaScript for improved type safety, better tooling, and fewer runtime errors.

## Rules

- Use TypeScript for all new Node.js projects of significant size
- Enable strict mode in tsconfig.json (`"strict": true`)
- Define interfaces and types for all data structures
- Avoid using `any` type -- use `unknown` if type is truly unknown
- Use type guards and discriminated unions for runtime type checking
- Generate types from schemas using tools like `zod` or `ts-json-schema-generator`
- Use type inference where possible, but add explicit types for public APIs
- Configure path aliases in tsconfig.json for cleaner imports
- Use TypeScript's utility types (Partial, Pick, Omit, etc.)

## Example

```typescript
// tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "node",
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "outDir": "./dist",
    "rootDir": "./src"
  }
}
```

```typescript
// Good: strong typing
interface User {
  id: string;
  email: string;
  name: string;
  role: 'user' | 'admin';
  createdAt: Date;
}

interface CreateUserInput {
  email: string;
  name: string;
  role?: User['role'];
}

async function createUser(
  input: CreateUserInput
): Promise<User> {
  // TypeScript ensures we handle all fields correctly
  return await db.users.create({
    ...input,
    id: generateId(),
    role: input.role ?? 'user',
    createdAt: new Date()
  });
}
```
