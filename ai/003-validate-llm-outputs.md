# Validate LLM Outputs

> Never trust raw LLM output — validate structure, content, and safety before passing results to downstream systems or users.

## Rules

- Always validate LLM outputs against an expected schema before use — parse JSON, check required fields, verify types
- Use schema validation libraries (Zod, Pydantic, JSON Schema) to enforce output contracts
- Implement retry logic with clarified prompts when validation fails — do not silently pass invalid data
- Set a maximum retry count (2-3 attempts) to avoid infinite loops on persistently malformed outputs
- Sanitize LLM-generated content before rendering in HTML, executing as code, or inserting into databases
- Check for hallucinated URLs, emails, phone numbers, and other verifiable facts when accuracy matters
- Reject outputs that contain prompt injection attempts, jailbreak patterns, or leaked system prompts
- Log validation failures with the raw output for debugging and prompt improvement

## Example

```typescript
import { z } from "zod";

const ProductSchema = z.object({
  name: z.string().min(1).max(200),
  price: z.number().positive(),
  category: z.enum(["electronics", "clothing", "food", "other"]),
  description: z.string().max(500),
});

// Bad: trusting raw LLM output
async function extractProduct(text: string) {
  const response = await llm.complete(`Extract product info: ${text}`);
  return JSON.parse(response); // Could be anything!
}

// Good: validated LLM output with retry
async function extractProduct(text: string, maxRetries = 2): Promise<Product> {
  for (let attempt = 0; attempt <= maxRetries; attempt++) {
    const response = await llm.complete({
      system: "Extract product information. Return valid JSON only.",
      prompt: text,
    });

    try {
      const parsed = JSON.parse(response);
      return ProductSchema.parse(parsed);
    } catch (error) {
      logger.warn("llm_output_validation_failed", {
        attempt,
        error: error.message,
        raw_output: response,
      });

      if (attempt === maxRetries) {
        throw new Error(
          `Failed to extract valid product after ${maxRetries + 1} attempts`,
        );
      }
    }
  }
}
```
