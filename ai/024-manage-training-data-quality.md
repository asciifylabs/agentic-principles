# Manage Training Data Quality

> Curate, version, and validate training and evaluation data with the same rigor as production code — data quality is the single biggest lever for model quality.

## Rules

- Version your datasets alongside your code — tag dataset versions and link them to the model versions trained on them
- Validate data quality before training: check for duplicates, missing fields, label inconsistencies, class imbalance, and encoding issues
- Maintain a strict separation between training, validation, and test sets — never let evaluation data leak into training
- Document data provenance: record where each dataset came from, how it was collected, what transformations were applied, and who reviewed it
- Clean and preprocess data consistently: apply the same normalization, tokenization, and formatting pipeline to training and inference data
- Review a random sample of labeled data for accuracy before training — even small label error rates compound into significant model degradation
- Implement data quality checks in CI/CD: schema validation, distribution drift detection, and anomaly flagging
- Remove or flag personally identifiable information (PII) and sensitive data from training sets before use
- Track dataset statistics (size, class distribution, domain coverage) and monitor for drift over time

## Example

```python
# Bad: unversioned, unvalidated training data
with open("data.json") as f:
    training_data = json.load(f)
model.train(training_data)  # No validation, no versioning

# Good: versioned, validated data pipeline
from pydantic import BaseModel, Field
from datetime import datetime

class TrainingExample(BaseModel):
    input: str = Field(min_length=1, max_length=10000)
    output: str = Field(min_length=1)
    label: str
    source: str

class DatasetManifest(BaseModel):
    version: str
    created_at: datetime
    total_examples: int
    label_distribution: dict[str, int]
    sources: list[str]

def validate_dataset(data: list[dict]) -> tuple[list[TrainingExample], list[str]]:
    """Validate dataset and return valid examples with error log."""
    valid = []
    errors = []

    for i, item in enumerate(data):
        try:
            example = TrainingExample(**item)
            valid.append(example)
        except ValidationError as e:
            errors.append(f"Row {i}: {e}")

    # Check for duplicates
    inputs = [ex.input for ex in valid]
    dupes = len(inputs) - len(set(inputs))
    if dupes > 0:
        errors.append(f"Found {dupes} duplicate inputs")

    # Check class balance
    labels = [ex.label for ex in valid]
    distribution = {l: labels.count(l) for l in set(labels)}
    min_count, max_count = min(distribution.values()), max(distribution.values())
    if max_count > min_count * 10:
        errors.append(f"Severe class imbalance: {distribution}")

    logger.info("dataset_validated", valid=len(valid), errors=len(errors))
    return valid, errors
```
