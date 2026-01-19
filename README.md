# plat-cms

CMS based on https://github.com/spurtcms

xplat driven: https://github.com/joeblew999/xplat, /Users/apple/workspace/go/src/github.com/joeblew999/xplat

## Quick Start

```bash
# First time setup
xplat task setup

# Start everything (PostgreSQL + CMS)
xplat task up

# Or start individually
xplat task db:up
xplat task go:run
```

## Admin Access

- **URL**: http://localhost:8080/admin
- **Username**: `Admin`
- **Password**: `Admin@123`

## Available Tasks

```bash
xplat task --list        # Show all tasks
xplat task setup         # Full initial setup
xplat task up            # Start all services
xplat task down          # Stop all services

# Source
xplat task src:fetch     # Clone SpurtCMS source
xplat task src:clean     # Remove fetched source

# Go (all use GOWORK=off)
xplat task go:run        # Run CMS
xplat task go:dev        # Run with hot reload
xplat task go:build      # Build binary
xplat task go:test       # Run tests
xplat task go:lint       # Run linter
xplat task go:mod        # Tidy modules
xplat task go:install    # Install to GOBIN
xplat task go:clean      # Clean build artifacts

# Database
xplat task db:up         # Start PostgreSQL
xplat task db:down       # Stop PostgreSQL
xplat task db:reset      # Reset database (destroys data)
```

## Configuration Without GUI

Most settings can be configured without using the web GUI:

### 1. Environment Variables (`.src/spurtcms/.env`)

```env
# Database
DATABASE_TYPE='postgres'
DB_HOST='localhost'
DB_PORT='5432'
DB_USERNAME='postgres'
DB_PASSWORD='postgres'
DB_NAME='spurtcms'

# Server
PORT='8080'
BASE_URL='http://localhost:8080/'

# Timezone & Language
TIME_ZONE='UTC'
DEFAULT_LANGUAGE='English'

# AWS S3 (optional, for media storage)
AWS_ACCESS_KEY_ID=''
AWS_SECRET_ACCESS_KEY=''
AWS_DEFAULT_REGION=''
AWS_BUCKET=''
```

### 2. SQL Database Seeding

Default data is inserted via `cms.sql`. Key tables:

| Table | Purpose |
|-------|---------|
| `tbl_users` | Admin users (password is bcrypt hashed) |
| `tbl_general_settings` | Logo, date/time format, timezone |
| `tbl_languages` | Available languages |
| `tbl_channels` | Content types (Blog, News, Jobs, etc.) |
| `tbl_mstr_blocks` | Reusable content blocks |

### 3. Blocks System

SpurtCMS uses **Blocks** - reusable content components. By default, blocks are fetched from a remote registry, but you can make them fully local.

#### Block Management Tasks

```bash
# Fetch all 32 blocks from SpurtCMS registry (one-time)
xplat task blocks:fetch

# Seed fetched blocks into your database
xplat task db:seed-remote

# Or use your own local blocks
xplat task db:seed

# Disable remote fetching (offline mode)
xplat task blocks:local

# Re-enable remote fetching
xplat task blocks:remote
```

#### Remote vs Local Blocks

| Mode | Pros | Cons |
|------|------|------|
| **Remote** (default) | Always latest blocks | Requires internet, depends on SpurtCMS server |
| **Local** | Works offline, full control | Manual updates needed |

#### Block Registry URLs

```env
MASTER_BLOCKS_ENDPOINTURL="https://superadmin.spurtcms.com/defaultblocklist/"
MASTER_CTA_ENDPOINTURL="https://superadmin.spurtcms.com/defaultctalist/"
MASTER_CHANNELS_ENDPOINTURL="https://superadmin.spurtcms.com/admin/channels/"
```

Set `MASTER_BLOCKS_ENDPOINTURL=""` to disable remote fetching.

#### Available Blocks (32 from registry)

Blocks include: Hero sections, Card grids, CTAs, Feature lists, Testimonials, Pricing tables, FAQs, Footers, and more. Run `xplat task blocks:fetch` to download them all.

### 4. Programmatic Setup via GraphQL

SpurtCMS exposes a GraphQL API at `http://localhost:8084/query` for programmatic content management:

```env
GRAPHQL_URL='http://localhost:8084/'
GRAPHQL_API_URL='http://localhost:8084/query'
GRAPHQL_PORT='8084'
```

## Architecture

```
plat-cms/
├── .src/spurtcms/      # SpurtCMS source (cloned)
│   ├── controllers/    # HTTP handlers
│   ├── models/         # Database models
│   ├── graphql/        # GraphQL schema & resolvers
│   ├── migration/      # DB migrations
│   └── .env            # Runtime config
├── docs/adr/           # Architecture Decision Records
├── scripts/            # Utility scripts (block fetching)
├── seeds/              # SQL seed files for blocks
├── docker-compose.yml  # PostgreSQL container
├── Taskfile.yml        # xplat task definitions
└── xplat.yaml          # Package manifest
```

## Key Features

- **Channels**: Content types (Blog, News, Jobs, Ecommerce, etc.)
- **Entries**: Individual content items within channels
- **Blocks**: Reusable content components
- **Forms**: Form builder with CTA support
- **GraphQL API**: Programmatic content access
- **Multi-tenant**: Supports multiple sites
