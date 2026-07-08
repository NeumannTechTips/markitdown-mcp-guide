# 08 · Troubleshooting

These are the failure modes you will actually encounter, with their causes and fixes. They are ordered roughly by how often they occur.

## `uvx: command not found`

**Cause.** `uv` is installed but not yet on your `PATH`, or it was installed in a terminal session that has since closed.

**Fix.** Open a new terminal so the updated `PATH` is loaded, then retry `uvx --version`. If it still fails, re-run the `uv` installer for your operating system (see [03-prerequisites.md](03-prerequisites.md)).

## The server installs but the host never sees it

**Cause.** This is the most common `pip`-route failure. You installed `markitdown-mcp` into a virtual environment, but the host launches a bare `markitdown-mcp` command that resolves against a different Python environment where the package is absent.

**Fix.** Give the host the absolute path to the executable inside your virtual environment, for example `/path/to/.venv/bin/markitdown-mcp`, rather than the bare command. Alternatively, switch to the `uvx` route, which sidesteps the problem entirely.

## The server is not listed in the host after editing the config

**Cause.** The host was not fully restarted. Most hosts load MCP servers only on a fresh launch, and closing the window does not reload them.

**Fix.** Quit the application completely (for example `Cmd/Ctrl + Q`, not just the window close button) and reopen it. Then check the host's developer or MCP settings panel to confirm `markitdown` is listed.

## A converted file comes back empty

**Cause.** The file is a scanned or image-only PDF with no text layer. The MCP path has no OCR, so there is nothing to extract.

**Fix.** Use the MarkItDown **Python library** with Azure Document Intelligence, run a dedicated OCR step before conversion, or in a coding host pass the page images to the model directly. The MCP tool deliberately does not expose OCR.

## A container cannot find a local file

**Cause.** You passed a host path to a containerised server. The container cannot see your filesystem unless you mount it, and even then it uses container paths.

**Fix.** Mount the directory and reference the container path:

```bash
podman run --rm -i -v /home/user/data:/workdir markitdown-mcp:latest
```

A host file at `/home/user/data/report.pdf` becomes `file:///workdir/report.pdf` inside the container.

## Permission denied on a mounted volume (Fedora / SELinux)

**Cause.** SELinux is blocking the container from reading the mounted directory.

**Fix.** Add the `:Z` (private label) or `:z` (shared label) suffix to the mount:

```bash
podman run --rm -i -v /home/user/data:/workdir:Z markitdown-mcp:latest
```

## A request to convert a `file:` URI is refused in a hosted service

**Cause.** This is expected and correct if you have restricted URI schemes for security. A public-facing service should generally refuse `file:` to prevent reading arbitrary local files.

**Fix.** This is working as intended. If local conversion is genuinely required, run the service in an isolated environment with an allow-listed directory, as described in [07-security.md](07-security.md).

## The tool exists but the model never calls it

**Cause.** The model did not recognise that conversion was needed, or the request was ambiguous.

**Fix.** Be explicit. Instead of "look at this file", say "convert `file:///...` to markdown and then ...". Naming the conversion intent and supplying a full URI reliably triggers the tool.

## Network or download failures during `uvx` first run

**Cause.** `uvx` fetches the package on first use; a restricted or offline network will block this.

**Fix.** Ensure outbound access to the Python package index on first run, or pre-install with `pip` into an environment that the host can launch. In fully air-gapped environments, build the container image on a connected machine and transfer it.

## Still stuck?

Validate the server in isolation with the MCP Inspector (see [06-validation-and-testing.md](06-validation-and-testing.md)). If the Inspector can invoke `convert_to_markdown` successfully but your host cannot, the problem is host configuration, not the server. If the Inspector itself fails, the problem is the installation or the file in question.

For defects in MarkItDown itself, search or raise an issue upstream at https://github.com/microsoft/markitdown/issues.
