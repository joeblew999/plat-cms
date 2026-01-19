# ADR-0003: xplat Issues and Fixes

## Status
Proposed

## Context

While setting up plat-cms with xplat, several issues were discovered that should be fixed in xplat itself.

## Issues Found

### 1. `xplat service start --with-ui` - UI command not registered

**Problem:** The service tries to run `xplat ui` when `--with-ui` is passed, but that command doesn't exist:

```
Error: unknown command "ui" for "xplat"
```

**Evidence from source:**
- `/internal/webui/` package exists with full Via-based UI implementation
- `/internal/service/service.go:109` calls `exec.Command(p.xplatBin, "ui", "--no-browser", "-p", p.uiPort)`
- But no `ui` command is registered in `/cmd/xplat/cmd/`

**Proposed Fix:**
1. Create `/cmd/xplat/cmd/ui.go` that registers the `ui` command
2. Wire it to call `web.StartVia()` from the webui package
3. Accept flags: `--port`/`-p`, `--no-browser`, `--taskfile`, `--dir`

**Suggested command structure:**
```bash
xplat ui                    # Start UI on default port 3000, open browser
xplat ui -p 8000            # Start on port 8000
xplat ui --no-browser       # Don't open browser (for service mode)
```

### 2. `xplat gen process` requires packages

**Problem:** Running `xplat gen process` says "No installed packages with process configuration found" even though `xplat.yaml` has a `processes:` section.

**Current behavior:**
```bash
$ xplat gen process
No installed packages with process configuration found.
Install packages first with: xplat pkg install <package>
```

**Expected behavior:** Should generate `process-compose.yaml` from the local `xplat.yaml` processes section.

**Workaround:** Manually created `process-compose.yaml`:
```yaml
version: "0.5"
processes:
  postgres:
    command: docker compose up postgres
    readiness_probe:
      exec:
        command: pg_isready -h localhost -p 5432
  cms:
    command: task go:run
    depends_on:
      postgres:
        condition: process_healthy
```

**Proposed Fix:**
1. `xplat gen process` should read local `xplat.yaml` processes section
2. Convert to process-compose.yaml format
3. Merge with any installed package processes

### 3. Port standardization unclear

**Problem:** Various xplat services use different default ports but there's no clear documentation or conflict detection:

| Service | Default Port | Notes |
|---------|-------------|-------|
| Task UI | 3000 | Via web framework |
| MCP HTTP | 8080? | Conflicts with many apps |
| process-compose API | 8080 | Default PC port |

**Proposed Fix:**
1. Document standard port allocations
2. Add port conflict detection on startup
3. Consider higher port ranges to avoid conflicts (e.g., 13000, 13001, etc.)

### 4. Service logs not visible during startup

**Problem:** When `xplat service start` fails, there's no immediate feedback. Had to manually check `/Users/apple/xplat.err.log`.

**Proposed Fix:**
1. Show last N lines of error log on startup failure
2. Or stream logs briefly during startup to show progress

### 5. xplat.yaml processes format differs from process-compose

**Problem:** The `xplat.yaml` processes section uses a simplified format that differs from `process-compose.yaml`:

```yaml
# xplat.yaml format (current)
processes:
  postgres:
    command: docker compose up postgres
    port: 5432
    readiness_probe:
      exec:
        command: pg_isready -h localhost -p 5432

# process-compose.yaml format (required)
processes:
  postgres:
    command: docker compose up postgres
    readiness_probe:
      exec:
        command: pg_isready -h localhost -p 5432
      initial_delay_seconds: 2
      period_seconds: 5
```

**Proposed Fix:**
1. Either make xplat.yaml match process-compose format exactly
2. Or have `xplat gen process` translate between formats (adding defaults for missing fields)

## Recommendations

### Priority 1 (Blocking)
- [ ] Register `xplat ui` command that calls `web.StartVia()`

### Priority 2 (Improves DX)
- [ ] Make `xplat gen process` read local xplat.yaml
- [ ] Show error log snippet on service start failure

### Priority 3 (Nice to have)
- [ ] Document standard port allocations
- [ ] Add port conflict detection

## Implementation Notes

The webui package at `/internal/webui/via_server.go` is complete and functional. It just needs:

```go
// cmd/xplat/cmd/ui.go
package cmd

import (
    "context"
    "github.com/spf13/cobra"
    web "github.com/joeblew999/xplat/internal/webui"
)

var uiPort string
var uiNoBrowser bool
var uiTaskfile string
var uiDir string

var UICmd = &cobra.Command{
    Use:   "ui",
    Short: "Start Task UI web interface",
    Long:  `Start a web-based UI for running Taskfile tasks.`,
    RunE: func(cmd *cobra.Command, args []string) error {
        cfg := web.DefaultViaConfig()
        cfg.Port = uiPort
        cfg.OpenBrowser = !uiNoBrowser
        if uiTaskfile != "" {
            cfg.Taskfile = uiTaskfile
        }
        if uiDir != "" {
            cfg.WorkDir = uiDir
        }
        return web.StartVia(context.Background(), cfg)
    },
}

func init() {
    RootCmd.AddCommand(UICmd)
    UICmd.Flags().StringVarP(&uiPort, "port", "p", "3000", "Port to listen on")
    UICmd.Flags().BoolVar(&uiNoBrowser, "no-browser", false, "Don't open browser on start")
    UICmd.Flags().StringVarP(&uiTaskfile, "taskfile", "t", "", "Path to Taskfile.yml")
    UICmd.Flags().StringVarP(&uiDir, "dir", "d", "", "Working directory")
}
```

## References

- xplat source: `/Users/apple/workspace/go/src/github.com/joeblew999/xplat`
- webui package: `/internal/webui/via_server.go`
- service package: `/internal/service/service.go`
