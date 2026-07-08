# Examples

Worked prompts and snippets you can paste into an MCP host once MarkItDown-MCP is registered.

## Convert a remote URL

```
Convert https://raw.githubusercontent.com/microsoft/markitdown/main/README.md to markdown and summarise what the project does.
```

## Convert a local file (STDIO / native install)

```
Convert file:///home/user/documents/report.pdf to markdown and list every heading.
```

## Convert a local file (container topology)

First start the server with a mount:

```bash
podman run --rm -i -v /home/user/documents:/workdir:Z markitdown-mcp:latest
```

Then reference the container path:

```
Convert file:///workdir/report.pdf to markdown and extract the conclusions.
```

## Extract a table from a spreadsheet

```
Convert file:///workdir/quarterly-figures.xlsx to markdown and show the first table.
```

## Convert a data URI

```
Convert data:text/plain;base64,SGVsbG8sIFdvcmxkIQ== to markdown.
```

## Verify the tool fired

Most hosts display tool calls in an expandable panel. Expand it after any prompt above to confirm `convert_to_markdown` was invoked and inspect the raw Markdown returned.
