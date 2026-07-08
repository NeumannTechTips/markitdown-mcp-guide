# 04 · Installation

This document covers every installation route, from the simplest to the most isolated. Pick the one that matches your trust boundary. All routes expose the identical tool, `convert_to_markdown(uri)`, so your host configuration logic is the same regardless of which you choose.

> Throughout, the silence after starting the server in STDIO mode is expected and correct. The server is waiting for a client to connect over standard input and output. Press `Ctrl+C` to stop it.

---

## Route A — `uvx` (recommended, zero-install)

This is the cleanest route. `uvx` fetches and caches the package on first run.

**Step 1.** Confirm `uv` is installed (see [03-prerequisites.md](03-prerequisites.md) if not):

```bash
uvx --version
```

**Step 2.** Start the server in STDIO mode to confirm it runs:

```bash
uvx markitdown-mcp
```

A silent prompt that does not return is success. Press `Ctrl+C`.

**Step 3.** Use this command in your host configuration:

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

That is the entire installation. Continue to **[05-client-integration.md](05-client-integration.md)**.

---

## Route B — `pip` in a virtual environment

Use this route if you prefer an explicit, pinned environment, or if `uv` is unavailable.

**Step 1.** Create and activate a dedicated virtual environment:

```bash
python3 -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
```

**Step 2.** Install the package:

```bash
pip install markitdown-mcp
```

**Step 3.** Confirm the server runs in STDIO mode:

```bash
markitdown-mcp
```

Silence is success. Press `Ctrl+C`.

> **Important.** If you install with `pip` into a virtual environment, your host must launch the *same* environment. A bare `markitdown-mcp` command only resolves when that environment is active. The robust pattern is to give the host the absolute path to the executable inside the virtual environment, for example `/path/to/.venv/bin/markitdown-mcp`. This is the single most common cause of a server that installs cleanly but never connects.

---

## Route C — Container (Podman or Docker)

Containerisation gives you isolation and reproducibility, and is the recommended approach when running the server for a desktop host that benefits from a clean, self-contained process. The examples use Podman; substitute `docker` for an identical result.

**Step 1.** Obtain the image. Build it from the upstream repository, or pull a published image if your registry provides one:

```bash
# Build from source (clone the upstream repo first)
git clone https://github.com/microsoft/markitdown.git
cd markitdown/packages/markitdown-mcp
podman build -t markitdown-mcp:latest .
```

**Step 2.** Run the server. For remote URIs only, no mount is needed:

```bash
podman run --rm -i markitdown-mcp:latest
```

**Step 3 — local file access.** A container cannot see your filesystem by default. To convert local files you must mount the directory and then reference *container* paths, not host paths:

```bash
podman run --rm -i -v /home/user/data:/workdir markitdown-mcp:latest
```

With the mount above, a host file at `/home/user/data/report.pdf` is referenced inside the container as `file:///workdir/report.pdf`. Forgetting this and passing the host path is the most common container-setup failure.

**Step 4.** Use this command in your host configuration:

```json
{
  "mcpServers": {
    "markitdown": {
      "command": "podman",
      "args": [
        "run", "--rm", "-i",
        "-v", "/home/user/data:/workdir",
        "markitdown-mcp:latest"
      ]
    }
  }
}
```

### A note for Fedora and Podman users

Podman runs rootless and daemonless by default, which is a good fit for a converter that reads your documents. If your host launches the container under a restricted user, ensure that user can access both the Podman socket and the mounted directory. SELinux on Fedora may require the `:Z` or `:z` mount suffix so the container can read the volume:

```bash
podman run --rm -i -v /home/user/data:/workdir:Z markitdown-mcp:latest
```

Use `:Z` for a private, unshared label and `:z` for a shared label. Apply this only if you see permission-denied errors on the mounted path.

---

## Route D — HTTP / SSE endpoint (advanced, localhost)

Run the server as a persistent local endpoint when multiple hosts need to share one converter instance.

**Step 1.** Start the server in HTTP mode, bound to localhost:

```bash
markitdown-mcp --http --host 127.0.0.1 --port 3001
```

This serves Streamable HTTP at `/mcp` and SSE at `/sse`.

**Step 2.** Point your host at the endpoint. The exact configuration key depends on the host, but the URL is `http://127.0.0.1:3001/mcp` (or the `/sse` path for SSE clients).

> **Security warning.** The server has no authentication and runs with the privileges of the user who starts it. It binds to localhost precisely so it is not reachable from the network. Do **not** bind it to `0.0.0.0` or a public interface unless you place an authenticating reverse proxy in front of it and fully understand the implications. Any process on the same machine can otherwise reach the tool and read any file the server's user can access. See **[07-security.md](07-security.md)**.

---

## Choosing a route

| Route | Best for | Network surface | Isolation |
| --- | --- | --- | --- |
| **A · uvx** | Most users, fastest start | None (STDIO) | Process-level |
| **B · pip** | Pinned, explicit environments | None (STDIO) | Virtual environment |
| **C · Container** | Reproducibility, untrusted inputs | None (STDIO in container) | Strong (container) |
| **D · HTTP/SSE** | Shared local service | Localhost only | Process-level |

When in doubt, start with **Route A**. Move to **Route C** when you want a strong isolation boundary around the conversion process.

Next: **[05-client-integration.md](05-client-integration.md)**.
