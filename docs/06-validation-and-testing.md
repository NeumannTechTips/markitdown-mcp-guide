# 06 · Validation and Testing

Do not assume the integration works because the configuration was accepted. Prove it. This document gives you three levels of validation, from the server in isolation through to a full host conversation.

## Level 1 — The server starts

Confirm the package runs at all. In STDIO mode, a server that starts and waits silently is healthy:

```bash
uvx markitdown-mcp
```

If this returns immediately with an error, or prints `command not found`, resolve that first — see **[08-troubleshooting.md](08-troubleshooting.md)**. Press `Ctrl+C` to stop.

## Level 2 — The MCP Inspector

The MCP Inspector exercises the server independently of any AI host, which isolates server problems from host problems. This is the single most useful validation step.

**Step 1.** Launch the Inspector against the server:

```bash
npx @modelcontextprotocol/inspector uvx markitdown-mcp
```

**Step 2.** Open the Inspector UI in your browser at the address it prints (commonly `http://localhost:5173`).

**Step 3.** In the Inspector, confirm that:

- The server connects successfully.
- Exactly one tool is listed: `convert_to_markdown`.
- The tool's input schema shows a single `uri` parameter.

**Step 4.** Invoke the tool manually. Provide a known-good URI, for example a small public web page:

```
https://raw.githubusercontent.com/microsoft/markitdown/main/README.md
```

You should receive Markdown back in the result pane. A successful manual invocation here proves the server is fully functional; any subsequent failure is a host configuration problem, not a server problem.

## Level 3 — End-to-end through the host

Now validate the complete loop inside your AI host.

**Test A — a remote URL.** Ask the host:

```
Convert https://raw.githubusercontent.com/microsoft/markitdown/main/README.md to markdown and tell me what the project does in two sentences.
```

The host should call `convert_to_markdown`, receive the Markdown, and answer from it. Many hosts show the tool call in an expandable panel; expand it to confirm the tool fired.

**Test B — a local file.** Place a small `.docx` or `.pdf` somewhere accessible and ask:

```
Convert file:///absolute/path/to/sample.docx to markdown and list its headings.
```

For the container topology, remember to use the *container* path, for example `file:///workdir/sample.docx`, and ensure the directory is mounted.

**Test C — a structured table.** Conversion quality is most visible on tabular data. Convert a spreadsheet and check that the table survives as a Markdown table:

```
Convert file:///absolute/path/to/data.xlsx to markdown and show me the first table.
```

## A validation checklist

| Check | Expected result |
| --- | --- |
| Server starts in STDIO mode | Silent, non-returning prompt |
| Inspector connects | "Connected" status |
| Tool count | Exactly one (`convert_to_markdown`) |
| Manual Inspector invocation | Markdown returned |
| Host converts a remote URL | Tool fires, grounded answer |
| Host converts a local file | Tool fires, correct content |
| Table fidelity | Markdown table preserved |

## What a healthy conversion looks like

Good output preserves the semantic skeleton: headings appear as `#` lines, lists as `-` or `1.` items, tables as pipe-delimited Markdown, and links as `[text](url)`. Visual styling (fonts, colours, exact spacing) is intentionally discarded. If headings and tables survive, the conversion is working as designed.

## When a conversion comes back empty

The most common cause is a scanned, image-only PDF with no underlying text layer. The MCP path has no OCR, so there is nothing to extract. Options:

- Run the document through the MarkItDown **Python library** with Azure Document Intelligence.
- Pre-process the file with a dedicated OCR step before conversion.
- In a coding host, pass page images to the model directly.

Proceed to **[07-security.md](07-security.md)** before any production use.
