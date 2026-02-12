# Use ESLint and Prettier

> Enforce code quality and consistent formatting with ESLint and Prettier configured for your project.

## Rules

- Always configure ESLint for linting and Prettier for formatting
- Use established style guides (Airbnb, Standard, or create your own)
- Configure ESLint and Prettier to work together (use `eslint-config-prettier`)
- Run linting and formatting in pre-commit hooks using `husky` and `lint-staged`
- Fix auto-fixable issues automatically, fail CI on unfixable issues
- Enable TypeScript-aware ESLint rules if using TypeScript
- Configure editor integration for immediate feedback
- Never disable rules without good reason and documentation

## Example

```json
// .eslintrc.json
{
  "extends": [
    "eslint:recommended",
    "plugin:node/recommended",
    "prettier"
  ],
  "plugins": ["node"],
  "env": {
    "node": true,
    "es2022": true
  },
  "parserOptions": {
    "ecmaVersion": 2022
  },
  "rules": {
    "no-console": "warn",
    "no-unused-vars": ["error", { "argsIgnorePattern": "^_" }]
  }
}

// .prettierrc.json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5"
}

// package.json
{
  "lint-staged": {
    "*.js": ["eslint --fix", "prettier --write"]
  }
}
```
