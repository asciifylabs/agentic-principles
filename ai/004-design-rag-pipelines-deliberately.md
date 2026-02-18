# Design RAG Pipelines Deliberately

> Build retrieval-augmented generation pipelines with intentional choices at every stage — ingestion, chunking, retrieval, and generation — to maximize relevance and minimize hallucination.

## Rules

- Define your retrieval quality metrics (precision, recall, MRR) before building the pipeline — you cannot optimize what you do not measure
- Choose chunking strategy based on your content type: fixed-size for uniform text, semantic chunking for mixed documents, page-level for structured reports
- Use 10-20% chunk overlap to prevent splitting key information across boundaries
- Store metadata (source, page number, timestamp, document type) alongside every chunk for filtering and attribution
- Retrieve more candidates than you need, then rerank — over-fetch and filter beats under-fetch and miss
- Include source citations in generated responses so users can verify claims against original documents
- Implement a feedback loop: track which retrieved chunks the model actually uses versus ignores
- Test the full pipeline end-to-end, not just individual components — retrieval quality and generation quality interact

## Example

```python
# Bad: naive RAG with no metadata or reranking
def answer(query):
    chunks = vector_store.search(query, k=3)
    context = "\n".join(chunks)
    return llm.complete(f"Context: {context}\n\nQuestion: {query}")

# Good: deliberate RAG pipeline with metadata, reranking, and citations
from dataclasses import dataclass

@dataclass
class Chunk:
    content: str
    source: str
    page: int
    score: float

def answer_with_sources(query: str) -> dict:
    # Over-fetch candidates
    candidates = vector_store.search(query, k=20)

    # Rerank for precision
    reranked = reranker.rank(query, candidates, top_k=5)

    # Build context with source tracking
    context_parts = []
    sources = []
    for i, chunk in enumerate(reranked):
        context_parts.append(f"[{i+1}] {chunk.content}")
        sources.append({"ref": i + 1, "source": chunk.source, "page": chunk.page})

    response = llm.complete(
        system="Answer based only on the provided context. Cite sources using [N] notation.",
        prompt=f"Context:\n{chr(10).join(context_parts)}\n\nQuestion: {query}",
    )

    return {"answer": response, "sources": sources}
```
