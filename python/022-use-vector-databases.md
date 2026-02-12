# Use Vector Databases

> Store and retrieve embeddings using vector databases for efficient semantic search and retrieval-augmented generation (RAG).

## Rules

- Use vector databases (FAISS, Pinecone, Chroma, Weaviate) for semantic search over large document sets
- Generate embeddings with appropriate models (OpenAI ada-002, sentence-transformers)
- Normalize embeddings before storage and use cosine similarity for retrieval
- Implement chunking strategies for large documents (500-1000 tokens per chunk)
- Store metadata alongside vectors for filtering and post-processing
- Use approximate nearest neighbor (ANN) algorithms for fast retrieval at scale
- Implement hybrid search combining vector similarity with keyword matching

## Example

```python
# Bad: linear search over all documents
def find_similar(query, documents):
    embeddings = [get_embedding(doc) for doc in documents]
    query_emb = get_embedding(query)
    similarities = [cosine_similarity(query_emb, emb) for emb in embeddings]
    return documents[max(range(len(similarities)), key=similarities.__getitem__)]

# Good: using FAISS for efficient vector search
import faiss
import numpy as np
from openai import OpenAI

client = OpenAI()

def get_embedding(text: str) -> np.ndarray:
    """Get embedding vector from OpenAI."""
    response = client.embeddings.create(
        model="text-embedding-ada-002",
        input=text
    )
    return np.array(response.data[0].embedding, dtype=np.float32)

class VectorStore:
    """Simple FAISS-based vector store."""

    def __init__(self, dimension: int = 1536):
        self.dimension = dimension
        self.index = faiss.IndexFlatIP(dimension)  # Inner product (cosine)
        self.documents = []

    def add_documents(self, documents: list[str]) -> None:
        """Add documents to the vector store."""
        embeddings = np.array([
            get_embedding(doc) for doc in documents
        ], dtype=np.float32)

        # Normalize for cosine similarity
        faiss.normalize_L2(embeddings)

        self.index.add(embeddings)
        self.documents.extend(documents)

    def search(self, query: str, k: int = 5) -> list[tuple[str, float]]:
        """Search for similar documents."""
        query_emb = get_embedding(query).reshape(1, -1)
        faiss.normalize_L2(query_emb)

        distances, indices = self.index.search(query_emb, k)

        results = [
            (self.documents[idx], float(score))
            for idx, score in zip(indices[0], distances[0])
        ]
        return results

# Usage
store = VectorStore()
store.add_documents([
    "Python is a programming language",
    "Machine learning uses algorithms",
    "Vector databases store embeddings"
])

results = store.search("What is Python?", k=2)
for doc, score in results:
    print(f"[{score:.3f}] {doc}")

# Better: using Chroma for persistent storage
import chromadb
from chromadb.utils import embedding_functions

# Initialize with OpenAI embeddings
openai_ef = embedding_functions.OpenAIEmbeddingFunction(
    api_key=OPENAI_API_KEY,
    model_name="text-embedding-ada-002"
)

client = chromadb.PersistentClient(path="./chroma_db")
collection = client.get_or_create_collection(
    name="documents",
    embedding_function=openai_ef,
    metadata={"hnsw:space": "cosine"}
)

# Add documents with metadata
collection.add(
    documents=["Python tutorial", "ML guide"],
    metadatas=[{"type": "tutorial"}, {"type": "guide"}],
    ids=["doc1", "doc2"]
)

# Query with metadata filtering
results = collection.query(
    query_texts=["programming languages"],
    n_results=2,
    where={"type": "tutorial"}
)
```
