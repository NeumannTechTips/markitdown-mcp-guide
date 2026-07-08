# Repository Structure

This page documents the layout of the repository so contributors and readers can navigate it quickly.

```
markitdown-mcp-guide/
│
├── README.md                          # Landing page and five-minute quick start
├── LICENSE                            # MIT licence
├── CONTRIBUTING.md                    # Contribution guidelines
├── CHANGELOG.md                       # Version history
├── STRUCTURE.md                       # This file
├── .gitignore
│
├── docs/                              # The full guide, in reading order
│   ├── 01-overview.md                 # What MarkItDown and MCP are, and why
│   ├── 02-architecture.md             # Reference architecture and sequence flow
│   ├── 03-prerequisites.md            # What to install first
│   ├── 04-installation.md             # Every install route, step by step
│   ├── 05-client-integration.md       # Per-host registration
│   ├── 06-validation-and-testing.md   # Proving it works
│   ├── 07-security.md                 # Trust boundaries and hardening
│   ├── 08-troubleshooting.md          # Real failure modes and fixes
│   ├── 09-rag-pipeline-integration.md # Feeding the vector / RAG pipeline
│   └── 10-faq.md                      # Concise answers to common questions
│
├── assets/
│   └── diagrams/                      # Technology-agnostic SVG diagrams
│       ├── 01-reference-architecture.svg
│       ├── 02-sequence-flow.svg
│       ├── 03-token-efficiency-infographic.svg
│       └── 04-deployment-topologies.svg
│
├── config-templates/                 # Validated, paste-ready configurations
│   ├── claude-desktop/
│   │   ├── config.uvx.json
│   │   └── config.container.json
│   ├── claude-code/
│   │   └── setup.sh
│   ├── cursor/
│   │   └── mcp.json
│   ├── vscode/
│   │   └── mcp.json
│   └── generic/
│       ├── stdio.json
│       └── http-sse.json
│
├── examples/                         # Worked prompts and a smoke test
│   ├── README.md
│   └── smoke-test.sh
│
└── .github/
    └── workflows/
        └── validate.yml              # CI: validates JSON and SVG on every push
```

## Reading order

For a first read, follow `docs/` in numerical order. For a quick deployment, the `README.md` quick start plus the relevant template under `config-templates/` is sufficient.
