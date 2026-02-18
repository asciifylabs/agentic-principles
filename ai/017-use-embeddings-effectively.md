# Use Embeddings Effectively

> Choose embedding models, dimensions, and similarity metrics that match your retrieval needs — embeddings are the foundation of semantic search quality.

## Rules

- Select embedding models based on your domain and task: general-purpose models (OpenAI text-embedding-3, Cohere embed) for broad use, domain-specific models for specialized content
- Normalize embedding vectors before storage and use cosine similarity for comparison — unnormalized vectors produce inconsistent results with dot product
- Match embedding dimensions to your latency and storage constraints: higher dimensions capture more nuance but cost more to store and search
- Use the same embedding model for both indexing and querying — mixing models produces meaningless similarity scores
- Batch embedding requests to reduce API latency and cost — embed 100 texts in one call, not 100 separate calls
- Store embeddings persistently — recomputing them on every query wastes time and money
- Re-embed your entire corpus when you change embedding models — old and new embeddings are incompatible
- Test embedding quality with your actual queries: compute precision@k and recall@k on a labeled test set before deploying

## Example

```python
# Bad: embedding one at a time with no normalization
def search(query, documents):
    query_emb = embed(query)
    for doc in documents:
        doc_emb = embed(doc)  # Re-embeds every search!
        score = dot_product(query_emb, doc_emb)  # Unnormalized

# Good: batch embedding with normalization and persistence
import numpy as np
from openai import OpenAI

client = OpenAI()

def embed_batch(texts: list[str], model: str = "text-embedding-3-small") -> np.ndarray:
    """Embed texts in batch and normalize."""
    response = client.embeddings.create(model=model, input=texts)
    embeddings = np.array([item.embedding for item in response.data], dtype=np.float32)

    # L2 normalize for cosine similarity via dot product
    norms = np.linalg.norm(embeddings, axis=1, keepdims=True)
    return embeddings / norms

def build_index(documents: list[str]) -> tuple[np.ndarray, list[str]]:
    """Build a searchable embedding index."""
    # Batch embed all documents
    embeddings = embed_batch(documents)
    # Persist to disk or vector store
    np.save("embeddings.npy", embeddings)
    return embeddings, documents

def search(query: str, embeddings: np.ndarray, documents: list[str], k: int = 5):
    """Search using precomputed embeddings."""
    query_emb = embed_batch([query])  # Normalized
    scores = (embeddings @ query_emb.T).squeeze()  # Cosine similarity via dot product
    top_k = np.argsort(scores)[-k:][::-1]
    return [(documents[i], float(scores[i])) for i in top_k]
```
