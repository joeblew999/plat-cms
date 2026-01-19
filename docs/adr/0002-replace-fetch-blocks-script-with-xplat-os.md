# ADR-0002: Replace fetch-blocks.sh with xplat os commands

## Status
Proposed

## Context

The `scripts/fetch-blocks.sh` script fetches blocks from the SpurtCMS registry and generates SQL. It currently uses:
- `curl` for HTTP requests
- `jq` for JSON processing
- `mkdir`, `cat`, `sed` for file operations

These dependencies may not be available on all platforms (especially Windows) and require separate installation.

xplat provides cross-platform equivalents via `xplat os`:
- `xplat os fetch` - HTTP downloads
- `xplat os jq` - JSON processing with jq syntax
- `xplat os mkdir`, `xplat os cat` - File operations

## Decision

Replace `scripts/fetch-blocks.sh` with inline Taskfile commands using xplat os utilities.

## Current Implementation

```bash
# scripts/fetch-blocks.sh
curl -s "$BLOCKS_URL" -H "Accept: application/json"
echo "$BLOCKS_JSON" | jq -c '.all_list[]'
mkdir -p "$OUTPUT_DIR"
```

## Proposed Implementation

```yaml
# Taskfile.yml
blocks:fetch:
  desc: Fetch blocks from SpurtCMS registry
  vars:
    BLOCKS_URL: https://superadmin.spurtcms.com/defaultblocklist/
    OUTPUT_FILE: seeds/remote-blocks.sql
  cmds:
    - xplat os mkdir -p seeds
    - |
      xplat os fetch {{.BLOCKS_URL}} --header "Accept: application/json" -o /tmp/blocks.json
    - |
      # Process JSON and generate SQL using xplat os jq
      xplat os jq '.all_list | length' /tmp/blocks.json
      # ... generate SQL file
```

## Consequences

### Positive
- Works on Windows, macOS, Linux without additional dependencies
- No need to install curl, jq separately
- Single binary (xplat) provides all utilities
- Consistent behavior across platforms

### Negative
- Slightly more verbose syntax
- Need to verify xplat os jq supports all required jq features
- Complex shell logic may still need bash/sh

## Implementation Notes

1. Test `xplat os fetch` with custom headers
2. Test `xplat os jq` with complex queries (`.all_list[]`, string escaping)
3. May need to keep bash fallback for complex string processing
4. Consider a hybrid approach: use xplat os for fetch/mkdir, but keep jq processing in a simpler form

## References

- `xplat os --help`
- `xplat os fetch --help`
- `xplat os jq --help`
- Current script: `scripts/fetch-blocks.sh`
