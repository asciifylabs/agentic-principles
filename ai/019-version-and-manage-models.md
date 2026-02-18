# Version and Manage Models

> Track model versions, configurations, and performance metrics in a registry — reproducibility and safe rollback require knowing exactly what is running in production.

## Rules

- Register every model version (fine-tuned, prompt configuration, or API model snapshot) with its metadata: training data version, hyperparameters, evaluation scores, and deployment date
- Use a model registry (MLflow, Weights & Biases, SageMaker Model Registry) to store and manage model artifacts
- Tag models with lifecycle stages: development, staging, production, archived — enforce promotion workflows between stages
- Never deploy a model to production without passing automated evaluation gates
- Maintain a rollback path: keep the previous production model version ready for instant revert
- Track which model version is serving each environment and tie it to observability data
- Version the full model configuration: model ID, system prompt, temperature, max tokens, tools — not just the model name
- Implement canary deployments for model updates: route a small percentage of traffic to the new version and monitor quality metrics before full rollout
- Document what changed between model versions and why — enable forensic analysis when quality issues arise

## Example

```python
# Bad: model config scattered across code with no versioning
response = client.messages.create(
    model="claude-sonnet-4-5-20250929",
    temperature=0.7,
    messages=messages,
)

# Good: versioned model configuration with registry
from dataclasses import dataclass, asdict
from datetime import datetime

@dataclass(frozen=True)
class ModelConfig:
    """Immutable, versioned model configuration."""
    version: str
    model_id: str
    system_prompt: str
    temperature: float
    max_tokens: int
    tools: list[str] | None = None

    def to_dict(self) -> dict:
        return asdict(self)

# Model registry
CONFIGS = {
    "summarizer-v1.0": ModelConfig(
        version="1.0",
        model_id="claude-sonnet-4-5-20250929",
        system_prompt="Summarize concisely in 2-3 sentences.",
        temperature=0.3,
        max_tokens=256,
    ),
    "summarizer-v1.1": ModelConfig(
        version="1.1",
        model_id="claude-sonnet-4-5-20250929",
        system_prompt="Summarize in 2-3 sentences. Focus on actionable insights.",
        temperature=0.2,
        max_tokens=256,
    ),
}

PRODUCTION = "summarizer-v1.1"
ROLLBACK = "summarizer-v1.0"

def get_model_config(config_name: str = PRODUCTION) -> ModelConfig:
    config = CONFIGS[config_name]
    logger.info("model_config_loaded", version=config.version, model=config.model_id)
    return config
```
