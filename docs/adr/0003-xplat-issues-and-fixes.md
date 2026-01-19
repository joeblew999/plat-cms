# ADR-0003: xplat Issues and Fixes

## Status
Mostly Resolved

**Issue #1 (ui command):** ✅ Fixed - committed to xplat main (72f9f77, a765f57, 680045e)
**Issue #3 (ports):** ✅ Already solved - xplat uses 876x port range
**Issue #4 (auto-start UI):** ✅ Already works - UI enabled by default in service config

## Context

While setting up plat-cms with xplat, several issues were discovered. Most turned out to be already solved or just needed the missing ui command.

## Issues Found

### 1. `xplat service start --with-ui` - UI command not registered ✅ FIXED

**Problem:** The service tried to run `xplat ui` but that command didn't exist.

**Fix:** Created `/cmd/xplat/cmd/ui.go` that:
- Registers the `ui` command
- Uses config.DefaultUIPort (8760) and config.DefaultProcessComposePort (8761)
- Supports flags: `--port`, `--no-browser`, `--taskfile`, `--dir`, `--pc-port`

**Commits:**
- 72f9f77: Initial ui command
- 680045e: Use config constants for default ports

### 2. `xplat gen process` requires packages (Still Open)

**Problem:** Running `xplat gen process` says "No installed packages with process configuration found" even though `xplat.yaml` has a `processes:` section.

**Workaround:** Manually create `process-compose.yaml`.

**Future Fix:**
1. `xplat gen process` should read local `xplat.yaml` processes section
2. Convert to process-compose.yaml format
3. Merge with any installed package processes

### 3. Port standardization ✅ ALREADY SOLVED

**Discovery:** xplat already uses a well-defined 876x port range!

| Service | Default Port | Constant |
|---------|-------------|----------|
| Task UI | 8760 | `config.DefaultUIPort` |
| Process Compose API | 8761 | `config.DefaultProcessComposePort` |
| MCP HTTP | 8762 | `config.DefaultMCPPort` |
| Webhook server | 8763 | `config.DefaultWebhookPort` |

**External tools keep their defaults:**
- Hugo: 1313
- Caddy admin: 2019

The ui.go I initially created used hardcoded "3000" - this was fixed in commit 680045e.

### 4. UI auto-start ✅ ALREADY WORKS

**Discovery:** The service config at `~/.xplat/service.yaml` defaults to:
- `ui: true` (UI enabled by default)
- `mcp: true` (MCP enabled by default)
- `sync: true` (GitHub sync enabled by default)

So `xplat service start` already starts the UI automatically. No `--with-ui` flag needed.

### 5. Port conflict detection (Future ADR)

**Problem:** Port conflicts are detected at runtime but not prevented proactively.

**Recommendation:** Create separate ADR for port conflict detection system:
- Pre-check port availability before starting services
- Suggest alternative ports if conflicts found
- Show which process is using the conflicting port

### 6. xplat.yaml processes format (Minor)

The xplat.yaml processes section uses a slightly simplified format. This is by design - `xplat gen process` should translate and add defaults like `initial_delay_seconds`.

## Recommendations

### Completed ✅
- [x] Register `xplat ui` command
- [x] Use config constants for ports (8760, 8761)
- [x] Fix outdated port comments in service_config.go

### Priority 2 (Improves DX)
- [ ] Make `xplat gen process` read local xplat.yaml
- [ ] Show error log snippet on service start failure

### Priority 3 (Separate ADR)
- [ ] Port conflict detection and resolution

## References

- xplat source: `/Users/apple/workspace/go/src/github.com/joeblew999/xplat`
- Port config: `/internal/config/config.go` (lines 40-52)
- Service config: `/internal/config/service_config.go`
- UI command: `/cmd/xplat/cmd/ui.go`
