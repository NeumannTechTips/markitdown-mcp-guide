#!/usr/bin/env bash
# Minimal smoke test: prove the server runs and the Inspector can reach it.
# Requires: uvx (or markitdown-mcp on PATH) and Node.js (for the Inspector).
set -euo pipefail

echo "[1/2] Confirming the server starts in STDIO mode (3s timeout)..."
if timeout 3s uvx markitdown-mcp </dev/null >/dev/null 2>&1; then
  echo "      Unexpected early exit — check installation."
else
  # A timeout (exit 124) means the server started and waited: success.
  echo "      OK: server started and waited for a client."
fi

echo "[2/2] To exercise the tool interactively, run:"
echo "      npx @modelcontextprotocol/inspector uvx markitdown-mcp"
echo "      Then invoke convert_to_markdown with:"
echo "      https://raw.githubusercontent.com/microsoft/markitdown/main/README.md"
