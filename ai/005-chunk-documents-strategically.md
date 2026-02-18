# Chunk Documents Strategically

> Split documents into chunks that preserve semantic coherence and context — chunk size, overlap, and strategy directly impact retrieval quality.

## Rules

- Start with recursive character splitting at 400-512 tokens with 10-20% overlap as a baseline — tune from there based on measured retrieval quality
- Match chunk size to your use case: smaller chunks (200-400 tokens) for precise fact retrieval, larger chunks (800-1500 tokens) for summarization and complex reasoning
- Respect natural document boundaries: prefer splitting at paragraph, section, or sentence boundaries over arbitrary character counts
- Include contextual metadata with each chunk: document title, section heading, page number, and position within the document
- Consider contextual chunking: prepend a brief document summary or section header to each chunk so it can stand alone without its surroundings
- Test chunking strategies empirically — measure retrieval precision and recall, not just chunk count
- Handle special content types (tables, code blocks, lists) as atomic units — never split a table row or code function across chunks
- Re-chunk when you change embedding models — different models perform optimally at different chunk sizes

## Example

```python
# Bad: fixed character split with no overlap or structure awareness
chunks = [text[i:i+500] for i in range(0, len(text), 500)]

# Good: recursive splitting with overlap and metadata
from langchain.text_splitter import RecursiveCharacterTextSplitter

splitter = RecursiveCharacterTextSplitter(
    chunk_size=512,
    chunk_overlap=64,         # ~12% overlap
    separators=["\n\n", "\n", ". ", " "],  # Prefer paragraph > line > sentence > word
    length_function=token_counter,
)

chunks = splitter.split_text(document_text)

# Better: contextual chunks with metadata
def chunk_with_context(document: dict) -> list[dict]:
    """Chunk document and attach context to each chunk."""
    raw_chunks = splitter.split_text(document["content"])

    return [
        {
            "content": f"From '{document['title']}', section '{document.get('section', 'N/A')}':\n\n{chunk}",
            "metadata": {
                "source": document["source"],
                "title": document["title"],
                "chunk_index": i,
                "total_chunks": len(raw_chunks),
            },
        }
        for i, chunk in enumerate(raw_chunks)
    ]
```
