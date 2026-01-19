# ADR 0001: Use xplat with SpurtCMS

## Status

Accepted

## Context

We need a CMS solution that is:
- Cross-platform (macOS, Linux, Windows)
- Easy to develop, build, and deploy
- Composable with shared tasks and processes across projects

SpurtCMS (https://github.com/spurtcms) is an open-source CMS written in Go that provides the core content management functionality we need.

xplat (https://github.com/joeblew999/xplat) is a cross-platform development tool that consolidates multiple development tools (Task, process-compose, etc.) into a single binary.

## Decision

We will use xplat to manage the development, build, and deployment lifecycle of this CMS project, which is based on SpurtCMS.

### Key Benefits

1. **Single Binary**: xplat embeds Task, process-compose, and various CLIs - no need to install them separately
2. **Composability**: Can share tasks and processes across plat-* projects
3. **Cross-Platform**: Works identically on macOS, Linux, and Windows
4. **Manifest-Driven**: Single `xplat.yaml` defines languages, binaries, environment variables, and processes
5. **Generation**: Auto-generates .gitignore, .env, CI workflows from the manifest

### Workflow

1. Bootstrap: `xplat manifest bootstrap`
2. Generate config files: `xplat gen all`
3. Run tasks: `xplat task <name>`
4. Orchestrate services: `xplat process`
5. Install packages: `xplat pkg install <name>`

## Consequences

### Positive

- Simplified developer onboarding - just install xplat
- Consistent tooling across all environments
- Can leverage packages from other xplat projects
- Built-in MCP server for AI IDE integration

### Negative

- Dependency on xplat tooling
- Team members need to learn xplat commands

## References

- SpurtCMS: https://github.com/spurtcms
- xplat: https://github.com/joeblew999/xplat
