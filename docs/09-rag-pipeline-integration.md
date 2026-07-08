# 09 · RAG Pipeline Integration

This document explains how the Markdown produced by MarkItDown-MCP feeds a retrieval-augmented generation (RAG) pipeline. It is deliberately technology-agnostic: the stages described here hold whether you use one embedding model or another, and whichever vector database you prefer.

## Where conversion sits

MarkItDown-MCP is the **ingestion and normalisation layer**. It performs the *convert at the boundary* step: every incoming artefact, whatever its original format, becomes one clean Markdown stream before anything downstream touches it.

![Token efficiency and pipeline position](../assets/diagrams/03-token-efficiency-infographic.svg)

This single decision pays off three times over. It lowers token cost, it improves model comprehension because Markdown is natively understood, and — most valuable for a pipeline — it gives every later stage a uniform input. Your chunker, embedder, and retriever never need to know whether a document began as a PDF, a spreadsheet, or a web page.

## The end-to-end flow

### Stage 1 — Conversion (MarkItDown-MCP)

The agent calls `convert_to_markdown(uri)` and receives structured Markdown. Headings, lists, tables, and links are preserved; visual styling is discarded. This structure is not cosmetic — it is the signal that later stages exploit.

### Stage 2 — Chunking and segmentation

Long Markdown must be split into retrievable units. Because MarkItDown preserves heading hierarchy, you can chunk *semantically* rather than by blind character count: split on heading boundaries so that each chunk is a coherent section. Heading-aware chunking materially improves retrieval quality, because a chunk that maps to a real section is a better unit of meaning than an arbitrary 500-character window that straddles two topics.

Practical guidance:

- Respect heading boundaries first, then apply a size cap within each section.
- Carry a small overlap between adjacent chunks to preserve context across boundaries.
- Attach metadata to every chunk: source URI, document title, heading path, and position. This metadata drives filtering at retrieval time.

### Stage 3 — Embedding

Each chunk is passed through an embedding model, which maps the text into a dense vector — a fixed-length array of floating-point numbers that captures semantic meaning. Chunks with similar meaning land close together in the vector space. The choice of embedding model determines the dimensionality of these vectors and the semantic quality of the space.

### Stage 4 — Vector storage and indexing

The embeddings are written to a **vector database**, which builds an **approximate nearest-neighbour (ANN)** index over them. The ANN index is what makes retrieval fast at scale: rather than comparing a query against every stored vector, it narrows the search to a small candidate set. Similarity is typically measured by cosine similarity or dot product. Store the chunk text and its metadata alongside each vector so that retrieval returns usable content, not just an identifier.

### Stage 5 — Retrieval

At query time, the user's question is embedded with the *same* embedding model, and the vector database returns the **top-k** most similar chunks. Two refinements are common and worth adopting:

- **Metadata filtering.** Constrain the search to a subset — a particular document, date range, or source — using the metadata attached in Stage 2.
- **Hybrid search.** Combine dense vector similarity with traditional keyword (sparse) search to catch exact-match terms that pure semantic search can miss.

### Stage 6 — Generation

The retrieved chunks are assembled into a grounded prompt and supplied to the model alongside the user's question. The model answers *from the retrieved context*, which reduces hallucination and lets you cite sources. Because the context arrived as clean Markdown, the model reads it efficiently and accurately.

## Why Markdown specifically helps RAG

- **Token economy at scale.** Stripping markup before embedding means you index and retrieve less noise, and you pay for fewer tokens at generation time.
- **Structure aids chunking.** Preserved headings give you natural, semantically meaningful split points.
- **Table fidelity aids retrieval.** Tables converted to Markdown tables remain queryable as structured data, rather than collapsing into unreadable cell dumps.
- **Uniformity simplifies the stack.** One input format means one chunking strategy, one embedding path, and one retrieval interface.

## A reference flow, restated

```
Mixed source files
        │  convert_to_markdown(uri)   ← MarkItDown-MCP (the boundary)
        ▼
Clean structured Markdown
        │  heading-aware chunking + metadata
        ▼
Chunks
        │  embedding model
        ▼
Dense vectors
        │  write + ANN index
        ▼
Vector database
        │  top-k retrieval (+ metadata filter, + hybrid)
        ▼
Grounded context  →  LLM generation  →  cited answer
```

## Two integration patterns

**Agentic, on-demand (via MCP).** The agent converts files mid-conversation. This is ideal for interactive analysis and for workflows where documents arrive unpredictably. The MCP server is the right tool here.

**Batch ingestion (via the Python library).** For bulk indexing of a large corpus, drive the MarkItDown **Python library** directly in a batch job. The library exposes the advanced features — OCR, image captioning, Azure Document Intelligence — that the MCP tool does not, which matters when your corpus includes scanned documents. Use the MCP server for live agent use, and the library for pipeline ingestion.

## References

- MarkItDown repository — https://github.com/microsoft/markitdown
- Model Context Protocol — https://modelcontextprotocol.io
