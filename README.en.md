# dsh-stack

**A DeepSeek Harness "everything" stack — reproduce the exact running system by cloning.**

A reproducible DeepSeek Harness (dsh) runtime: the core harness + a dozen first-party/third-party bundle plugins + an embedded Flash/Pro auto-scheduler + four agent presets, all ready to run.

## What this is

This repo is not new code from scratch — it is the **reproducible assembly of a currently-running dsh system**. Clone it, configure the env vars and model keys, and you get a nearly identical setup:

- Every plugin's source is tracked; third-party and "second-creation" (fork) repos are documented.
- Built-in **Flash/Pro auto-scheduler** (`dsh-llm-auto-router`): classify each turn with the fast model, route light work to Flash and heavy work to Pro — **mode-independent, works in any preset**.
- Four agent presets included, with Chinese introduction.
- Config template is sanitized — no real secrets.

## Quick start (3 steps)

1. **Install DSH**
   ```bash
   git clone https://github.com/deepseek-ai/deepseek-harness
   cd deepseek-harness && pnpm install && pnpm build
   ```
   Needs Node `^22.19 || >=24` and `pnpm`.

2. **Assemble plugins** — each bundle is its own repo; follow `docs/PLUGINS.zh.md`:
   ```bash
   git clone https://github.com/lileikeji/dsh-llm-auto-router
   cd dsh-llm-auto-router && pnpm install && pnpm build
   dsh plugin --profile web add /path/to/dsh-llm-auto-router
   ```

3. **Configure models & env**
   - `cp config-templates/settings.example.yaml ~/.dsh/settings.yaml`
   - `export OPENCODE_GO_API_KEY=... SILICONFLOW_API_KEY=... SILICONFLOW_MIMO_VISION_API_KEY=... AIJWS_API_KEY=...`
   - Install agent presets from `presets/` into `~/.dsh/.agent-presets/`

4. **Run**
   ```bash
   pnpm dsh --profile web
   ```
   Open the web GUI (default `http://127.0.0.1:3081`). New sessions use the `router-flash` preset + `deepseek-v4-auto` auto-scheduling.

## Layout

```
dsh-stack/
├── README.md / README.en.md        # docs (zh / en)
├── docs/PLUGINS.zh.md, PLUGINS.en.md
├── preset/                         # agent preset sources
├── config-templates/settings.example.yaml
└── scripts/
```

## Docs

- [Plugin manifest (origins & forks)](docs/PLUGINS.zh.md) / [English](docs/PLUGINS.en.md)
- [README.en.md](README.en.md)

## Auto-scheduling

With `dsh-llm-auto-router` installed and the default model `opencode-go / deepseek-v4-auto`:

| Work | Route |
|---|---|
| Light (chat / translate / format / quick lookup) | `deepseek-v4-flash` |
| Heavy (complex coding / debugging / deep reasoning / architecture / math) | `deepseek-v4-pro` |

Each turn's first request is classified once with the fast model (≤16 tokens); later steps reuse that decision. On classifier failure it falls back to the strong tier — never fails a turn. Only `model` is rewritten, never `provider`; mode-independent — works in any preset.

## Security

No real API keys, tokens, SSH hosts, or credentials are stored here. The `remote-web-ui` public URL / join token is not included (see the template comment). All model keys are injected via environment variables.

## License

Each plugin keeps its upstream license (mostly BSD-3 / MIT). This assembly (docs & templates) is MIT.
