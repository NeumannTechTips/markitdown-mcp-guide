# 05 · Client Integration

This document shows how to register the MarkItDown-MCP server with each major MCP host. The server is identical across all of them; only the location and shape of the configuration differs. Ready-to-paste files are provided under [`../config-templates/`](../config-templates/).

> **A universal rule for all hosts:** after editing any MCP configuration, you must fully restart the host application. Closing the window is not enough — most hosts only load MCP servers on a fresh launch. On desktop apps, quit completely (for example `Cmd/Ctrl + Q`) and reopen.

---

## Claude Desktop

**Step 1.** Open the configuration file. From within Claude Desktop, go to **Settings → Developer → Edit Config**, or edit the file directly:

- **macOS:** `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows:** `%APPDATA%\Claude\claude_desktop_config.json`
- **Linux:** `~/.config/Claude/claude_desktop_config.json`

**Step 2.** Add the server. For the `uvx` route:

```json
{
  "mcpServers": {
    "markitdown": {
      "command": "uvx",
      "args": ["markitdown-mcp"]
    }
  }
}
```

If you already have other servers, merge this entry into the existing `mcpServers` object rather than replacing it.

**Step 3.** Fully quit Claude Desktop and reopen it.

**Step 4.** Confirm. Reopen **Settings → Developer** and check that `markitdown` is listed as a running server. Then drop a PDF or Word file into the chat, or ask:

```
Convert file:///absolute/path/to/document.pdf to markdown and summarise it.
```

For the container route, use the [`config-templates/claude-desktop/config.container.json`](../config-templates/claude-desktop/config.container.json) template instead.

---

## Claude Code (CLI)

Claude Code offers a single-command registration, which is the quickest route of all:

```bash
claude mcp add markitdown -- uvx markitdown-mcp
```

To verify:

```bash
claude mcp list
```

You should see `markitdown` listed. Then, within a Claude Code session, ask it to convert a file by URI. To remove the server later:

```bash
claude mcp remove markitdown
```

---

## Cursor

**Step 1.** Open Cursor's MCP settings, or edit the configuration file directly:

- **Project-scoped:** `.cursor/mcp.json` in your project root
- **Global:** `~/.cursor/mcp.json`

**Step 2.** Add the server:

```json
{
  "mcpServers": {
    "markitdown": {
      "command": "uvx",
      "args": ["markitdown-mcp"]
    }
  }
}
```

**Step 3.** Restart Cursor. The tool becomes available to the agent automatically.

---

## Visual Studio Code

VS Code supports MCP servers through its agent tooling. Add an entry to your MCP configuration (commonly `.vscode/mcp.json` for a workspace, or the user-level equivalent):

```json
{
  "servers": {
    "markitdown": {
      "command": "uvx",
      "args": ["markitdown-mcp"]
    }
  }
}
```

Note that VS Code uses the key `servers` rather than `mcpServers`. Reload the window after saving.

---

## Any other MCP host (generic pattern)

Every compliant host follows the same conceptual model. Provide:

1. A **name** for the server (`markitdown`).
2. A **command** to launch it (`uvx`, or the absolute path to the executable, or `podman`).
3. The **arguments** for that command (`["markitdown-mcp"]`, or the container run arguments).

The generic STDIO template:

```json
{
  "mcpServers": {
    "markitdown": {
      "command": "uvx",
      "args": ["markitdown-mcp"]
    }
  }
}
```

For HTTP/SSE hosts, point the client at `http://127.0.0.1:3001/mcp` (Streamable HTTP) or `http://127.0.0.1:3001/sse` (SSE), having started the server with `markitdown-mcp --http --host 127.0.0.1 --port 3001`.

See [`../config-templates/generic/`](../config-templates/generic/) for both patterns.

---

## Configuration template index

| Host | Template |
| --- | --- |
| Claude Desktop (uvx) | [`config-templates/claude-desktop/config.uvx.json`](../config-templates/claude-desktop/config.uvx.json) |
| Claude Desktop (container) | [`config-templates/claude-desktop/config.container.json`](../config-templates/claude-desktop/config.container.json) |
| Claude Code | [`config-templates/claude-code/setup.sh`](../config-templates/claude-code/setup.sh) |
| Cursor | [`config-templates/cursor/mcp.json`](../config-templates/cursor/mcp.json) |
| VS Code | [`config-templates/vscode/mcp.json`](../config-templates/vscode/mcp.json) |
| Generic STDIO | [`config-templates/generic/stdio.json`](../config-templates/generic/stdio.json) |
| Generic HTTP/SSE | [`config-templates/generic/http-sse.json`](../config-templates/generic/http-sse.json) |

Once registered, validate the integration end to end with **[06-validation-and-testing.md](06-validation-and-testing.md)**.
