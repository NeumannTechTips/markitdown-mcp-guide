# 03 · Prerequisites

Before you install MarkItDown-MCP, confirm each item below. Validating these first prevents the great majority of setup failures.

## 1. Python 3.10 or higher

MarkItDown requires Python 3.10 or newer. Check your version:

```bash
python3 --version
```

If the output is below 3.10, install a newer interpreter through your platform's package manager or from python.org before continuing.

## 2. A package launcher: `uv` (recommended) or `pip`

You have two installation routes. The `uv` route is recommended because `uvx` fetches and caches the package on first run, with no manual virtual environment to manage and no risk of polluting a system Python.

**Install `uv`:**

```bash
# macOS / Linux
curl -LsSf https://astral.sh/uv/install.sh | sh

# Windows (PowerShell)
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

Confirm it is on your `PATH`:

```bash
uvx --version
```

If `uvx: command not found` appears, open a fresh terminal so the updated `PATH` is picked up, then retry.

The alternative is plain `pip`, in which case a dedicated virtual environment is strongly advised because MarkItDown's optional dependencies can conflict with other packages.

## 3. A container engine (only for the container topology)

If you intend to run the server inside a container — recommended for isolation, and required by some hosts for reliability — install **Podman** or **Docker**. On Fedora and other RHEL-family distributions, Podman is the native choice:

```bash
sudo dnf install -y podman
podman --version
```

Podman is daemonless and rootless by default, which makes it a sound option for running a converter that reads your files.

## 4. An MCP-compatible host

You need at least one MCP host to connect the server to. Any of the following work, and the integration steps differ only in where the configuration file lives:

- Claude Desktop
- Claude Code (CLI)
- Cursor
- Visual Studio Code (with an MCP-capable extension)
- Any other MCP-compliant agent

## 5. Optional: the MCP Inspector for validation

To prove the server works independently of any host, the MCP Inspector is invaluable. It requires Node.js and is run on demand with `npx`, so there is nothing to install ahead of time:

```bash
npx @modelcontextprotocol/inspector
```

Confirm Node.js is present:

```bash
node --version
```

## Pre-flight checklist

| Requirement | Command to verify | Needed for |
| --- | --- | --- |
| Python ≥ 3.10 | `python3 --version` | All routes |
| `uv` / `uvx` | `uvx --version` | Recommended install route |
| Podman or Docker | `podman --version` | Container topology only |
| An MCP host | (open the application) | All routes |
| Node.js | `node --version` | Validation with MCP Inspector (optional) |

Once every applicable row checks out, proceed to **[04-installation.md](04-installation.md)**.
