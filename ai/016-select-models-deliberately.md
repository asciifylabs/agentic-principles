# Select Models Deliberately

> Choose the right model for each task based on measured quality, cost, and latency trade-offs — never default to the most powerful model for everything.

## Rules

- Profile each task against multiple models: measure quality, latency, and cost per call — then pick the cheapest model that meets your quality threshold
- Use model routing: classify incoming requests by complexity and route simple tasks to fast/cheap models, complex tasks to capable/expensive ones
- Benchmark with your actual prompts and data, not generic benchmarks — model performance varies dramatically by task
- Plan for model deprecation: abstract the model identifier so you can swap models without code changes
- Re-evaluate model selection when providers release new models — a newer small model may outperform last year's large model at a fraction of the cost
- Use different models for different pipeline stages: a fast model for classification or routing, a capable model for generation
- Document why each model was chosen for each task with the evaluation data that justified the decision
- Never hardcode model names deep in application logic — configure them externally so they can be updated without redeployment

## Example

```python
# Bad: one model for everything
MODEL = "claude-opus-4-6"  # Expensive and slow for simple tasks

def classify(text):
    return call_llm(MODEL, f"Classify: {text}")

def generate_report(data):
    return call_llm(MODEL, f"Generate report: {data}")

# Good: task-appropriate model selection
from enum import Enum

class TaskComplexity(Enum):
    SIMPLE = "simple"    # Classification, extraction, formatting
    MODERATE = "moderate"  # Summarization, Q&A, analysis
    COMPLEX = "complex"  # Creative writing, multi-step reasoning, code generation

MODEL_MAP = {
    TaskComplexity.SIMPLE: "claude-haiku-4-5-20251001",
    TaskComplexity.MODERATE: "claude-sonnet-4-5-20250929",
    TaskComplexity.COMPLEX: "claude-opus-4-6",
}

def get_model(complexity: TaskComplexity) -> str:
    return MODEL_MAP[complexity]

def classify(text: str) -> str:
    model = get_model(TaskComplexity.SIMPLE)
    return call_llm(model, text)

def generate_report(data: str) -> str:
    model = get_model(TaskComplexity.COMPLEX)
    return call_llm(model, data)
```
