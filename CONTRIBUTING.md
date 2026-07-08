# Contributing

Thank you for considering a contribution to this guide.

## Scope

This repository documents how to integrate the upstream **markitdown-mcp**
server with MCP-compatible AI hosts. It is a documentation project. Bugs in
MarkItDown itself belong upstream at
https://github.com/microsoft/markitdown/issues.

## How to contribute

1. Open an issue describing the change before submitting a large pull request.
2. Keep instructions **validated** — every command and configuration must be
   tested against the current `markitdown-mcp` package before submission.
3. Match the existing tone: clear, precise, and vendor-neutral.
4. Use British English spelling and grammar.
5. Keep diagrams technology-agnostic. Source SVGs live in `assets/diagrams/`.

## Validating changes

- JSON templates must parse: `python3 -c "import json,sys; json.load(open(sys.argv[1]))" <file>`
- Shell scripts should pass `shellcheck` where available.
- Test any new command on at least one real MCP host before documenting it.

## Reporting problems

Open an issue with: your operating system, host application and version, the
exact configuration used, and the full error output.
