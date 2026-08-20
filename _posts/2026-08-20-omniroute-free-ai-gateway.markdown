---
title: "OmniRoute — A Free AI Gateway with Auto-Fallback"
date: 2026-08-20 10:30:00 +0200
description: "Install and configure OmniRoute, the MIT-licensed AI router that fronts 290+ providers (90+ with free tiers) behind one OpenAI-compatible endpoint, and run it as a systemd user service that survives reboot."
categories: [self-hosted, devops, ai]
tags: [omniroute, systemd, llm, free-models, gateway, linux]
layout: post
image: /jekyll-theme-kactus/assets/images/2026-08-20-omniroute-free-ai-gateway.svg
---

![OmniRoute gateway architecture — clients on the left, router in the middle, 290+ provider backends on the right](/jekyll-theme-kactus/assets/images/2026-08-20-omniroute-free-ai-gateway.svg)

Coding agents are only as good as the models behind them — and the billing shock when a long session burns through a paid API key. [OmniRoute](https://github.com/diegosouzapw/OmniRoute) is an MIT-licensed AI gateway that routes requests to the *right* model across **290+ providers** (90+ with free tiers) through a single OpenAI-compatible endpoint at `http://localhost:20128/v1`. It is the closest thing to free coding I've found: combine a few free API keys, an OAuth login or two, and an `auto` model string, and Claude Code / Codex / any OpenAI-compatible agent runs on models you never pay for.

This post covers what OmniRoute actually provides, how to install and configure it, what the free-model landscape looks like, and how to run it as a **systemd user service** so it starts on boot and survives logout.

## What OmniRoute is

At its core it is a smart router: one local server accepts OpenAI-format chat completions from any client, and forwards each request to the best available upstream — from a subscription you already pay for, an API key with remaining credits, or a free tier. If a provider rate-limits or dies mid-request, the router silently slides to the next candidate in milliseconds. That "auto-fallback" is the whole point: you never hit a wall mid-coding-session again.

The feature surface at the current release (v3.8.49):

- **290 providers / 500+ models** behind one `http://localhost:20128/v1` endpoint — every major lab plus long-tail free tiers.
- **19 routing strategies** — priority, cost-optimized, round-robin, least-used, `lkgp` (stick to the last-known-good provider), fusion (a panel of models + a judge), even prompt-cache-aware routing.
- **0 config starts** — a fresh install has keyless free providers (OpenCode Free, Felo) pre-wired into the `auto` combo, so `curl` works before you've added a single key.
- **Token compression** — stacked RTK + Caveman engines, averaging ~89% token savings on tool-heavy sessions per the project's benchmarks; huge for agent loops.
- **Resilience layers** — per-provider circuit breakers, per-connection exponential cooldowns, per-model lockouts; the combo keeps going when one endpoint gives up.
- **A local dashboard** (`/dashboard`) showing live usage analytics, quota, savings, and the aggregated free-tier budget (the "how many free tokens do I actually have left this month?" view).
- **One endpoint for every client** — Claude Code, Codex CLI, Cline, Kilo, Continue, Aider, OpenCode, and anything OpenAI-compatible (it even lists Hermes Agent as working out of the box).

## The free-model landscape

The headline number the project maintains is **~1.53B documented free tokens per month** across 43 *deduped* provider pools (≈2.15B in your first month once one-time signup credits land). They are deliberately honest about it: the figure excludes uncapped-but-rate-limited providers, because summing "10 RPM × 24/7 × 30 days" would be a fantasy number.

The biggest documented contributors:

| Provider pool | Free monthly tokens (documented, recurring) |
|---|---|
| Mistral | ~1.00B |
| LLM7 | ~150M |
| Groq | ~117M |
| Gemini (Flash family, pooled) | ~60M |
| Cerebras, Cloudflare AI, SambaNova | ~30M each |
| OpenRouter (with a one-time $10 top-up) | +~24M |

Plus a long tail of **permanently-free providers with no published token cap** — SiliconFlow, Z.AI GLM-Flash, Baidu, Kilo Code's gateway (rotating Nemotron-family free models), OpenCode Zen — and singles to add: Vertex ~300M and AgentRouter ~200M first-month credits, DeepSeek ~5M, Together $25, GLM-CN 20M signup bonus, etc.

> ⚠️ The project also publishes a ToS-attention table: a handful of providers' terms are fuzzy about proxying (personal-use clauses), some flag OAuth-based aggregation explicitly, and free tiers change constantly — Gemini, for example, is now Flash-family only. Re-check the [provider reference](https://github.com/diegosouzapw/OmniRoute/blob/main/docs/reference/FREE_TIERS.md) before relying on a figure. For a single-user, personal proxy it's worth skimming, and it's a judgment call per provider — the project's docs split it into `caution` / `ambiguous` / `ok` clearly.

## Installing

OmniRoute is a Node.js CLI shipped on npm and Docker. Any recent Node (18+/20+/22) works; the machine discussed here runs Node 22 via Homebrew.

```bash
# npm (global install) — the standard route
npm install -g omniroute

# or Docker — quick, no Node toolchain on the host needed
docker run -d -p 20128:20128 --name omniroute diegosouzapw/omniroute

# or via Homebrew/Linuxbrew on macOS/Linux
brew install omniroute   # if the formula exists in your tap
```

There's also an Electron desktop app and a PWA for the dashboard, but the CLI is the same server underneath.

Verify the install and the version:

```bash
omniroute --version
# 3.8.-era output
```

On first run, the server boots on **localhost:20128** and creates its state directory (`~/.omniroute/`) with the SQLite store, `.env` (where API keys land), and logs. It registers itself as a daemon-capable process.

## Configuring

**1. Start it once:**

```bash
omniroute
# OmniRoute — Smart AI Router with Auto Fallback
# Listening on http://localhost:20128
```

**2. Open the dashboard** at `http://localhost:20128/dashboard` — choose a provider card, and:

- **API-key providers** — paste a key (e.g. DeepSeek, Groq, Mistral, Cerebras keys; some offer big signup credits).
- **OAuth providers** — sign in via the built-in flows (GitHub Copilot, Claude, Grok Build, Kimi, Kiro, etc.).
- **Web providers** — paste a session cookie for *-web variants (e.g. HuggingChat).

Keys are stored encrypted at rest (AES-256-GCM) — the dashboard/lock screen note makes a point of never sending raw prompts through someone else's cloud.

**3. Configure a "combo"** — a named chain of models to fall through. `auto` (or `auto/cheap`, `auto/coding`, `auto/fast`, `auto/offline`) is a virtual combo built from your connected providers — you can also build your own chain mixing the 19 strategies.

**4. Point your agent at it.** For CLI tools that respect OpenAI env vars:

```bash
export ANTHROPIC_BASE_URL=http://localhost:20128/v1
export ANTHROPIC_AUTH_TOKEN=  # optional

export OPENAI_BASE_URL=http://localhost:20128/v1
# model: auto
```

or set the base URL in the tool's config (Claude Code: `claude setup`; Codex: `codex login use-local-connection`; etc.). Set the model name to `auto` and the router handles the rest.

**5. Sanity-test with curl:**

```bash
curl http://localhost:20128/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"auto","messages":[{"role":"user","content":"Hello!"}]}'
```

You should get a real completion from whatever provider OmniRoute judged best at that moment — often a free one.

The CLI also manages everything you'd expect: `omniroute providers` / `omniroute nodes` to list/health-check endpoints, `omniroute oauth` to manage logins, `omniroute compression` to tune the RTK/Caveman pipeline, `omniroute sessions` and `openapi` for introspection — run `omniroute --help` for the full command tree.

## Running it as a systemd user service

Manual launch dies with your shell. The production-grade move is a **user-level systemd unit** — no root, starts on login/boot, restarts on failure, logs to the journal. This mirrors the unit I use locally (paths generalized):

```ini
[Unit]
Description=Omniroute proxy service
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
# Node 22 Cellar bin on PATH so the npm wrapper resolves the right runtime
Environment="PATH=$HOMEDIR/.linuxbrew/lib/node_modules/.bin:$HOMEDIR/.linuxbrew/Cellar/node@22/22.23.2_1/bin"
ExecStart=$HOMEDIR/.linuxbrew/bin/omniroute
Restart=on-failure
RestartSec=5
KillMode=mixed
KillSignal=SIGTERM
TimeoutStopSec=30
StandardOutput=journal
StandardError=journal
WorkingDirectory=$HOMEDIR

[Install]
WantedBy=default.target
```

Place it at `~/.config/systemd/user/omniroute.service`, then:

```bash
# 1. Tell systemd about it
systemctl --user daemon-reload

# 2. Enable (start at boot/login) + start now
systemctl --user enable --now omniroute.service

# 3. Verify
systemctl --user status omniroute.service
journalctl --user -u omniroute.service -f
```

Notes on the details:

- **`After=network-online.target` / `Wants=`** — the unit waits for the network to be up since every upstream call needs it.
- **`Type=simple`** — the node process runs in the foreground, so systemd knows its lifecycle.
- **`ExecStart` uses an absolute path** — interactive-shell `$PATH` isn't inherited by systemd. If you installed via npm global, the binary lands in the npm prefix (`bin/omniroute`); if via Homebrew/Linuxbrew, it's `$HOMEDIR/.linuxbrew/bin/omniroute`. If your `npm i -g` prefix is different (e.g. `~/.local`, `~/.nvm/...`), put **that** path in, and add that prefix's `/bin` to `PATH` if needed. (In the example above the Linuxbrew-style prefix is also prepended to `PATH` alongside the Node runtime.)
- **`Environment="PATH=..."`** — includes the Cellar `node@22` bin so the launcher resolves the correct Node runtime when spawned by systemd (interactive shells pick it up via profile; systemd doesn't).
- **`KillMode=mixed`** — SIGKILL to the main process after `TimeoutStopSec` if it hangs, while letting children network sockets wind down.
- **`Restart=on-failure`** — restart only on unexpected exit codes; a manual `stop` doesn't bounce it.
- **`WorkingDirectory=$HOMEDIR`** — the process finds `~/.omniroute/` normalised regardless of which user starts it.

### The age-old bus problem: "Failed to connect to bus: No medium found"

`systemctl --user` connects to systemd over the user D-Bus bus living in `/run/user/$(id -u)`. On a headless server or a non-login SSH shell that socket often doesn't exist yet — and you get:

```
Failed to connect to bus: No medium found
```

Fix it once with **user lingering** (needs root):

```bash
sudo loginctl enable-linger YOUR_USERNAME
```

This makes systemd keep a persistent per-user instance (and its D-Bus bus) even with nobody logged in — the standard requirement for unattended user services. In a non-login automation context, also export the runtime dir and bus address first:

```bash
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
systemctl --user daemon-reload
```

After that, `enable --now` and `status` behave like any system service, and the logs are journal-backed.

## Cost reality check

The honest nuance, per the project's own free-tier methodology: the ~1.53B number is **documented recurring** tokens; one-time signup credits (Together $25, Vertex 300M, AgentRouter 200M, DeepSeek 5M…) boost month one; and "permanently free" providers are real but rate-limited with no token cap to count. Compression turns the real budget big — RTK + Caveman eat roughly 80–90% of tool-output tokens, which is what makes a 117M Groq / 30M Cerebras allowance go surprisingly far in agent loops.

What Is OmniRoute NOT? It's not a model provider — it doesn't sell tokens; it's the plumbing that picks the cheapest provider that works, per request, per combo, with the meta-level analytics. And it won't save you from a provider's ToS... hence the quick legal glance above, on which side of the line your use sits.

## Wrap-up

The whole CI loop I run with it — free key first, cheap fallback second, `auto` scoring the rest — costs about €0/month and behaves like a paid API but without the bill. Installing it is one npm/brew/curl command; making it persistent is a 20-line unit file. The free-model landscape shifts fast (this post's numbers are the project's own July/2026 snapshot at v3.8.49), but the router's job is to track it — so the budget dashboard stays more relevant over time than any list anyone writes down, including this one.

_Self-host-ingly,_ maybe. But first: `brew install omniroute` (or your equivalent), `omniroute`, `http://localhost:20128/dashboard`, add a key or OAuth, set `model: auto`, and never watch a rate-limit error again.