# 10 · Frequently Asked Questions

**What is the difference between MarkItDown and MarkItDown-MCP?**
MarkItDown is the underlying Python library and command-line tool. MarkItDown-MCP (`markitdown-mcp`) is a thin server that wraps the library and exposes it over the Model Context Protocol, so AI agents can call it. The MCP package pins `markitdown[all]` as a dependency, so installing it brings the full converter set.

**Which formats does it support?**
PDF, Word, PowerPoint, Excel, images (with EXIF and OCR in the library), audio (with transcription in the library), HTML, CSV, JSON, XML, EPUB, Outlook `.msg`, ZIP archives processed recursively, and YouTube URLs, among others.

**Does the MCP server do OCR on scanned PDFs?**
No. The MCP path has no OCR, so an image-only PDF returns empty. Use the Python library with Azure Document Intelligence, or a dedicated OCR step, for scanned documents.

**Can it convert Markdown back into PDF or Word?**
No. The conversion is strictly *files to Markdown*. The reverse direction belongs to tools such as Pandoc. Early directory listings sometimes mislabelled it as "markdown to PDF"; that is incorrect.

**How many tools does the server expose?**
Exactly one: `convert_to_markdown(uri)`. This is a deliberate design choice, so the model can never select the wrong tool and there is nothing to misconfigure.

**Which URI schemes are accepted?**
`http:`, `https:`, `file:`, and `data:`.

**Which transports does it support?**
STDIO (the default), Streamable HTTP, and Server-Sent Events (SSE).

**Is it secure to expose over the network?**
Not without additional measures. The server has no built-in authentication and runs with the privileges of its user. It binds to localhost by default for exactly this reason. Never bind it to a public interface without an authenticating reverse proxy in front. See [07-security.md](07-security.md).

**Does it write temporary files?**
No. Conversion is performed in memory, which benefits both performance and security.

**What Python version is required?**
Python 3.10 or higher.

**What licence is it under?**
The MIT Licence — permissive, allowing free use, modification, and distribution.

**Will the same configuration work across different AI clients?**
Yes. That is the value of MCP. The server is identical across hosts; only the location and key name of the configuration differ (for example, VS Code uses `servers` while most others use `mcpServers`).

**Why convert documents to Markdown at all before sending them to a model?**
Three reasons: lower token cost (Markdown is far leaner than raw markup), better comprehension (models read Markdown natively), and uniformity (one format simplifies every downstream stage of a pipeline). Reported field tests show token reductions of roughly 30 to 70 per cent.

**How do I prove my setup works?**
Use the MCP Inspector to invoke the tool in isolation, then run an end-to-end conversion inside your host. See [06-validation-and-testing.md](06-validation-and-testing.md).

**How does this fit a RAG pipeline?**
MarkItDown-MCP is the ingestion and normalisation layer. Its Markdown output is chunked, embedded into dense vectors, stored in a vector database with an approximate nearest-neighbour index, and retrieved at query time to ground the model's answers. See [09-rag-pipeline-integration.md](09-rag-pipeline-integration.md).

**Where should I report bugs?**
For this guide, open an issue in this repository. For defects in MarkItDown or MarkItDown-MCP themselves, use the upstream tracker at https://github.com/microsoft/markitdown/issues.
