# Plugin Manifest (origins & forks)

Tracks the complete plugin assembly of the `lileikeji` DSH system, so anyone can reproduce "clone-and-identical".

## Core platform

| Component | Origin | Notes |
|---|---|---|
| DeepSeek Harness (dsh) | https://github.com/deepseek-ai/deepseek-harness | plugin-based agent harness (vendored Cordis); runs on **`0.1.0-rc.7`** with local secondary-dev (see README "Version baseline") |

## Bundles (origin = git fetch; fork = has an upstream remote)

| Plugin | Bundle | Origin | Fork | Purpose |
|---|---|---|---|---|
| agent-team-room | `dsh-agent-team-room` | ishuowang/dsh-agent-team-room | - | persistent multi-agent rooms (membership/messaging/tasks/timeline). This assembly merges upstream room-mention/invite enhancements, keeping the local "footer entry disabled" secondary-dev |
| anchored-standard | `dsh-anchored-standard` | xiaobright/dsh-anchored-standard | - | preset: Minimal bootstrap then full tools |
| ankh-guard | `@khorsheed/dsh-ankh-guard` | Khorsheed/dsh-ankh-guard | - | green-build gate for self-modification restarts |
| auto-compact | `dsh-auto-compact` | lileikeji/dsh-auto-compact | - | auto context compaction (token-pressure threshold) |
| api-key-pool | `dsh-api-key-pool` | lileikeji/dsh-api-key-pool | **xiaozhe7772222/dsh-api-key-pool** (fork) | API key rotation pool (multi-key round-robin + failover + cooldown recovery). Fork adds: rc.8 keyed card compat, auto-list all connected providers via settings.describe, removed built-in example pools |
| auto-continue | `dsh-auto-continue` | lileikeji/dsh-auto-continue | - | auto-resume interrupted tasks |
| think-defaults | `dsh-think-defaults` | lileikeji/dsh-think-defaults | - | auto-fill reasoning efforts (thinking levels) for any new llm-pi-ai model |
| crosstalk | `@dsh-crosstalk/bundle` | lileikeji/dsh-crosstalk | **Jesse-njx/dsh-crosstalk** (fork) | cross-session messaging + event-driven auto-collab |
| image-gen | `dsh-image-gen` | lileikeji/dsh-image-gen | - | image gen chain + verification |
| launcher | `dsh-launcher` | lileikeji/dsh-launcher | - | Windows launcher (boot web + relay tunnel + browser) |
| llm-auto-router | `@dsh-external/dsh-llm-auto-router` | lileikeji/dsh-llm-auto-router | - | Flash/Pro auto-scheduler, mode-independent |
| mcp-agent-example | `dsh-mcp-agent-example` | lileikeji/dsh-mcp-agent-example | - | bridge official MCP tools as `mcp__<server>__<tool>` |
| memory | `dsh-agent-memory` | Culeot/dsh-agent-memory | - | cross-session long-term memory (remember/recall/index/forget over ctx.storage, schema-validated). Orthogonal to crosstalk/interconnect: memory=vertical accumulation, messaging=horizontal collaboration |
| relay-broker | `dsh-relay-broker` | lileikeji/dsh-relay-broker | - | multi-host relay (remote WebUI port forwarding, HMAC tokens) |
| routing-suite | `dsh-routing-suite` | yjh051108/dsh-routing-suite | - | routing research toolset (upstream) |
| session-doctor | `dsh-session-doctor` | mayf3/dsh-session-doctor | - | session diagnostics |
| super-injector | `@dsh-external/dsh-super-injector` | lileikeji/dsh-super-injector | - | runtime plugin injector (hot reload) |
| token-usage | `dsh-token-usage` | jiamuAi/dsh-token-usage | - | token usage stats UI |
| ui-image-render | `dsh-ui-image-render` | lileikeji/dsh-ui-image-render | - | UI image rendering |
| upgrader | `dsh-upgrader` | lileikeji/dsh-upgrader | - | one-click plugin upgrade |
| vision-assist | `dsh-vision-assist` | lileikeji/dsh-vision-assist | - | durable image understanding for image turns |
| vision-toolkit | `dsh-vision-toolkit` | lileikeji/dsh-vision-toolkit | - | structured vision tools (locate/crop/colors/pixel-diff) |
| vision-verify | `dsh-vision-verify` | lileikeji/dsh-vision-verify | - | visual verification |
| web-search-anysearch | `dsh-web-search-anysearch` | lileikeji/dsh-web-search-anysearch | - | AnySearch web search provider (ctx.web) |
| web-ui | `dsh-web-ui` | zhu1090093659/dsh-web-ui | - | third-party web UI |

## Agent presets

| preset | status | notes |
|---|---|---|
| `router-flash` | default | Flash routing by task type (build/fix), neutral persona + classify/recall/anti-runaway anchors (author w7, opencode-go) |
| `router-standard` | available | task-aware routing (fix→spec, build→react) |
| `anchored-standard` | available (experimental) | Minimal bootstrap then full tools |
| `liangshen` | available | V4 Pro 「梁神」 mode |

## Models / providers (sanitized)

| provider | purpose | models |
|---|---|---|
| `opencode-go` | primary dialogue | `deepseek-v4-auto` (auto Flash/Pro), `deepseek-v4-flash`, `deepseek-v4-pro` |
| `siliconflow-mimo-vision` | vision assist | `moonshotai/Kimi-K2.7-Code` |
| `aijws-openai` | backup DeepSeek route | `deepseek-v4-pro` |

> API keys are injected via environment variables (see `config-templates/settings.example.yaml`); no real credentials are stored in this repository.
