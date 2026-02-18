# Implement Hybrid Search

> Combine semantic vector search with keyword-based search (BM25) and reranking for retrieval that handles both meaning and exact terms.

## Rules

- Use hybrid search (vector + keyword) as the default retrieval strategy — pure vector search misses exact terms, pure keyword search misses semantics
- Implement reciprocal rank fusion (RRF) or weighted score combination to merge results from vector and keyword search
- Add a cross-encoder reranker after initial retrieval to improve precision on the final candidate set
- Tune the balance between vector and keyword scores based on your query patterns — technical queries benefit from stronger keyword weight
- Over-retrieve candidates (fetch 20-50) then rerank to top-k (5-10) — reranking is most effective when it has enough candidates to choose from
- Use metadata filters (date, source, document type) to narrow the search space before vector similarity
- Index keyword search with appropriate analyzers for your language and domain — stemming, stop words, and synonyms matter
- Benchmark hybrid search against pure vector search on your evaluation set — hybrid should consistently outperform on diverse query types

## Example

```python
# Bad: vector-only search misses exact keyword matches
def search(query):
    return vector_store.similarity_search(query, k=5)

# Good: hybrid search with reranking
from dataclasses import dataclass

@dataclass
class SearchResult:
    content: str
    source: str
    score: float

def hybrid_search(query: str, k: int = 5) -> list[SearchResult]:
    """Combine vector search, BM25, and reranking."""
    # Stage 1: over-retrieve from both indexes
    vector_results = vector_store.search(query, k=20)
    keyword_results = bm25_index.search(query, k=20)

    # Stage 2: reciprocal rank fusion
    fused = reciprocal_rank_fusion(
        [vector_results, keyword_results],
        weights=[0.6, 0.4],  # Favor semantic, but respect keywords
    )

    # Stage 3: rerank top candidates with cross-encoder
    candidates = fused[:20]
    reranked = cross_encoder.rerank(query, candidates, top_k=k)

    return reranked

def reciprocal_rank_fusion(result_lists: list, weights: list, k: int = 60) -> list:
    """Merge ranked lists using reciprocal rank fusion."""
    scores = {}
    for results, weight in zip(result_lists, weights):
        for rank, result in enumerate(results):
            doc_id = result.id
            scores[doc_id] = scores.get(doc_id, 0) + weight / (k + rank + 1)

    sorted_ids = sorted(scores, key=scores.get, reverse=True)
    return [get_document(doc_id) for doc_id in sorted_ids]
```
