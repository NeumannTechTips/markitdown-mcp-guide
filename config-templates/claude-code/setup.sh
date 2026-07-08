#!/usr/bin/env bash
# Register the MarkItDown-MCP server with Claude Code.
# Validated against: claude mcp add <name> -- <command> [args...]
set -euo pipefail

echo "Registering markitdown-mcp with Claude Code..."
claude mcp add markitdown -- uvx markitdown-mcp

echo "Done. Verifying registration:"
claude mcp list

echo
echo "To remove later, run: claude mcp remove markitdown"
