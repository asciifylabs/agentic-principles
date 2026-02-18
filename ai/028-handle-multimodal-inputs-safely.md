# Handle Multimodal Inputs Safely

> Validate, size-limit, and sanitize image, audio, and file inputs before sending them to multimodal models — untrusted media is an attack surface and a cost multiplier.

## Rules

- Validate file types, MIME types, and file sizes before processing — reject unsupported or suspiciously large files early
- Set maximum input dimensions for images: resize oversized images before sending to the model to control token costs
- Scan uploaded files for embedded prompt injection: images and PDFs can contain text designed to manipulate the model
- Strip EXIF metadata and other embedded data from images before processing — metadata can contain PII or location data
- Implement content-type-specific validation: verify image files are actually images, PDFs are valid PDFs, not renamed executables
- Calculate and monitor the token cost of multimodal inputs — images consume significantly more tokens than text descriptions
- Apply rate limits per user on multimodal inputs, which are more expensive and compute-intensive than text-only requests
- Provide fallback behavior when multimodal processing fails — degrade to text-only mode rather than erroring completely
- Log multimodal processing metadata (file type, dimensions, token cost) for cost analysis and abuse detection

## Example

```python
from PIL import Image
import io

# Bad: accepting any file and sending directly to the model
def analyze_image(file_bytes):
    return llm.complete_with_image(file_bytes, "Describe this image")

# Good: validated and size-controlled multimodal processing
MAX_IMAGE_SIZE_MB = 10
MAX_DIMENSION = 2048
ALLOWED_TYPES = {"image/jpeg", "image/png", "image/webp", "image/gif"}

def validate_image(file_bytes: bytes, content_type: str) -> bytes:
    """Validate and resize image for safe processing."""
    if content_type not in ALLOWED_TYPES:
        raise ValueError(f"Unsupported image type: {content_type}")

    if len(file_bytes) > MAX_IMAGE_SIZE_MB * 1024 * 1024:
        raise ValueError(f"Image exceeds {MAX_IMAGE_SIZE_MB}MB limit")

    # Verify it's actually an image
    try:
        img = Image.open(io.BytesIO(file_bytes))
        img.verify()
        img = Image.open(io.BytesIO(file_bytes))  # Re-open after verify
    except Exception:
        raise ValueError("Invalid image file")

    # Strip EXIF metadata
    clean_img = Image.new(img.mode, img.size)
    clean_img.putdata(list(img.getdata()))

    # Resize if too large
    if max(clean_img.size) > MAX_DIMENSION:
        clean_img.thumbnail((MAX_DIMENSION, MAX_DIMENSION))
        logger.info("image_resized", original=img.size, new=clean_img.size)

    buffer = io.BytesIO()
    clean_img.save(buffer, format="PNG")
    return buffer.getvalue()

def analyze_image(file_bytes: bytes, content_type: str, prompt: str) -> str:
    clean_image = validate_image(file_bytes, content_type)

    response = client.messages.create(
        model="claude-sonnet-4-5-20250929",
        max_tokens=1024,
        messages=[{
            "role": "user",
            "content": [
                {"type": "image", "source": {"type": "base64", "data": base64.b64encode(clean_image).decode()}},
                {"type": "text", "text": prompt},
            ],
        }],
    )

    return response.content[0].text
```
