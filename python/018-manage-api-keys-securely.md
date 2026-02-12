# Manage API Keys Securely

> Never hardcode API keys in source code; use environment variables and secret management systems to protect credentials.

## Rules

- Store API keys in environment variables, never commit them to version control
- Use `.env` files locally with `python-dotenv`, add `.env` to `.gitignore`
- Use secret management services in production (AWS Secrets Manager, HashiCorp Vault, Azure Key Vault)
- Rotate API keys regularly and have a process for key compromise
- Use different keys for development, staging, and production environments
- Never log API keys, even in debug mode
- Validate that required API keys are present at startup, fail fast if missing

## Example

```python
# Bad: hardcoded API key
import openai
openai.api_key = "sk-1234567890abcdef"  # NEVER DO THIS

# Good: using environment variables
import os
from openai import OpenAI

api_key = os.getenv("OPENAI_API_KEY")
if not api_key:
    raise ValueError("OPENAI_API_KEY environment variable not set")

client = OpenAI(api_key=api_key)

# Better: using python-dotenv for local development
from dotenv import load_dotenv
import os

load_dotenv()  # Load from .env file

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY")

if not OPENAI_API_KEY:
    raise ValueError("Required API keys not configured")

# Best: using Pydantic settings for validation
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    openai_api_key: str
    anthropic_api_key: str
    environment: str = "development"

    class Config:
        env_file = ".env"
        case_sensitive = False

settings = Settings()  # Validates all required keys exist
```

**.env.example:**

```bash
# Copy to .env and fill in your keys
OPENAI_API_KEY=sk-your-key-here
ANTHROPIC_API_KEY=sk-ant-your-key-here
ENVIRONMENT=development
```

**.gitignore:**

```
.env
.env.local
*.key
secrets/
```
