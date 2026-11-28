---
layout: post
title: "AI Tools Daily Update — November 28, 2026"
date: 2026-11-28 06:30:00 +0100
description: "23 new tools in three days. The orchestration layer is where differentiation lives now. MCP won. Memory is the new bottleneck. Cost collapse continues."
categories: [AI Tools, Daily Update]
tags: [coding-agents, mcp, orchestration, open-source, models, infrastructure]
image: /jekyll-theme-kactus/assets/images/ai-tools-daily-2026-11-28.svg
---

<img src="/jekyll-theme-kactus/assets/images/ai-tools-daily-2026-11-28.svg" alt="AI Tools Daily Update November 28 2026">

Four days since the last run. The agent layer keeps thickening — and the infrastructure layer is finally catching up.

I genuinely don't know how to feel about the volume this week. Twenty-three new tools in three days. That's not a typo.

---

## New Tools (Nov 25–27)

### Icons8 Hub — Swarm-native dispatcher for Claude Code/Codex
Launched November 26 on Product Hunt. Open source (Apache-2.0). A self-hosted coordinator that drives many Claude Code or Codex sessions in parallel from a browser or Telegram. Coordinator agent hands work to executors in isolated git worktrees; only decisions surface back. One feed of decisions instead of parallel-session chaos. One-line install: `curl -fsSL https://icons8.github.io/hub/install.sh | bash`. Experimental: no per-action permission prompts, not sandboxed. Free software; you pay your own model subscriptions.

### Pydantic Pax — Plugin-first terminal coding agent
Launched November 26 (beta, alongside Pydantic AI Harness). MIT licensed. Official terminal coding agent from Pydantic. Everything is a plugin: the coding agent, sandboxes, workspaces, MCP servers, integrations. `pax --agent my_module:agent` runs your own Pydantic AI agent in Pax's terminal with sessions, models, plugins around it. Code mode: model writes Python snippets calling many tools; Pax runs statements as they arrive. Speculative execution starts file reads before model finishes writing. Sandboxes: local micro-VM or hosted (E2B, boxd, Daytona, OpenSandbox, Modal, Render, Sprites, Kubernetes). Session persistence: resume, fork, rewind; `--resume-claude`/`--resume-codex` continues Claude Code/Codex sessions. Runs commands as you (no sandbox, no approval unless added). Free CLI; you pay the model/subscription you connect.

### DeskFleet — Shared team workspace for coding agents
Launched November 27 (Product Hunt, v0.24.0). Apache-2.0 (client, daemon, server). Connects Codex CLI, Claude Code, Cursor CLI, Grok CLI, Oh My Pi, DeepSeek Harness, or custom ACP agents on each team machine. Teammates join same live session: read conversation, queue follow-ups, steer active turns, approve permissions once. Live Git diffs, native PTY terminals, file transfers, remote desktop over WebRTC. Isolated git worktrees per session or live directories. Archive/restore without losing context. Built-in `@deskfleet/mcp` server per session for cross-machine context/schedules. Offline-readable history (local SQLite + centralized PostgreSQL sync). Credentials/repos stay on executing machine. Planned pricing: Starter $5/mo, Pro $20/mo ($200/yr). Self-hosted unlimited.

### ExtraOrbital — One-command backend provisioning for agents
Launched November 26 (Product Hunt). CLI: `npx extraorbital provision .` provisions databases, storage, auth, and an AI gateway; writes credentials to `.env`/`.env.local`. Free tier: $0 shared allowances + $5 small-model credit once; free bucket files deleted after 30 days; unused free projects deleted after 30 days. Pay-as-you-go: $20/member/mo + usage at supplier cost (no markup), prepaid credit ($5 start, auto-reload), backups included. Enterprise annual via sales.

### Bifura — Agent-readiness audit for websites
Launched November 26 (Product Hunt). Scores how AI agents/crawlers read your pages. Free score in under a minute (no account). Full report $14 one-time. Launch-week subscriptions locked until Dec 3: Starter $14.99/mo (reg $19), Pro $49/mo (reg $59), Agency $199/mo (reg $249) + $10.99/client. Weekly monitoring, Fix Preview, Slack alerts, daily tracking at higher tiers.

### GigaChat 4 — Sber's 708B MoE open weights
Announced November 26. 708B total / 41B active (GigaChat4-708B-A41B) and 37B/4B active (GigaChat4-37B-A4B). Both have native 1,048,576-token context. Instant + Reasoning modes in single checkpoint. DeepSeek Sparse Attention + Gated DeltaNet layers. MIT weights for large model (FP8, BF16, GGUF, base, intermediate checkpoints). SGLang native with MTP/DFlash2 speculative decoding. Setup notes for Pi, Codex CLI, DeepSeek Harness. SWE-bench Verified 80.89 (GLM-5.3 leads at 86.67). Hosted pricing unclear.

### GigaChat 3.5 Omni — Multimodal open-weight MoE
Announced November 27. 432B MoE / 28B active. Takes text, images, audio, video (with soundtrack) — answers in text. Video at 1 fps up to 512 frames, each frame followed by audio slice. 131K context. Three MTP heads for speculative decoding, OpenAI-style tool calls. FP8 checkpoint for SGLang (support in PR). Tested on 8×H100. Sber's table: Tencent WeMM-Video edges it on video-with-sound average (61.24 vs 61.17). MIT weights.

### Ming-Image-0.2-Design — Ant Group's 6B design-focused image model
Announced November 26. 6B params, optimized for e-commerce hero shots, UI design drafts, spatial renders. Better composition, lighting, text rendering than v0.1. Ranked #1 among open-weight models on Artificial Analysis AA-Image-T2I v2.1 (Nov 25). MIT weights on Hugging Face, vLLM-Omni recipes. Validated on single 80 GiB GPU. Defaults: 2048×2048, 12 steps.

### Koed — Local-first memory layer for coding agents
Launched November 25 (Product Hunt). Apache-2.0. Captures useful context from agent sessions and recalls it later so Claude Code, Codex, Pi can reuse project decisions instead of rediscovering them. Desktop app v1.2.0 for macOS (Apple silicon) and Linux (x64 AppImage); Windows coming soon (WSL). Install: `curl -fsSL https://koed.ai/install | bash` or build from source. Free self-hosted memory loop. Pro (hosted embeddings/recall on any device) and team sharing listed as "coming soon."

### Hurdle — Together AI's coding agent eval framework
Launched November 25. Open source npm library. Sets Claude Code or Codex loose on tasks you write; marks each run with code checks, LLM judge from plain-English rubric, guards that block banned actions (e.g., spinning up pricey GPU clusters). Run with/without your MCP server or skills, across models. Viewer shows pass rate, time, cost per run with full transcripts. Local runs (your machine/keys) or sandboxed (Together Sandbox, proxy swaps real keys). `npx hurdle init`, Node 22.18+.

### Cloudflare Search for Agents — Native agent-searchable indexing
Launched November 25 (beta). Toggle under Quick Actions builds AI Search index of your domain, puts search endpoint at `/.well-known/search`. Agents find it via meta tags, ask in keywords/plain English, get matching chunks back as Markdown (not generated answers — their own model does the thinking). Crawls up to 100K pages via sitemaps/links, hybrid vector+keyword search, daily refresh. Indexing/storage/queries count against AI Search pricing/plan limits.

### Perplexity Time Machine — Point-in-time web snapshots for agents
Launched November 25. Adds `snapshot_as_of` cutoff to Search API, Context API, Agent API (`web_search`, `fetch_url`). Every result from copy of page Perplexity had saved at/before that moment, up to 365 days back. Search API: results ranked against older copy, title/date/snippet from that copy. Context API: full text at cutoff. Agent API tools respect cutoff. Doesn't mix with recency/date filters or People Search. 1 req/sec rate limit.

### QA.tech MCP — Vision-based E2E testing via MCP
Launched November 27. Remote MCP at `api.qa.tech/v1/mcp` so Claude Code, Cursor, Codex can create/run vision-based E2E tests and pull failures without leaving IDE. Free trial 10 credits. Starter $89/mo (50 credits, MCP/API/CLI included). Growth/Enterprise custom.

### Tripo Studio MCP — 3D modeling via MCP
Launched November 27. Official hosted MCP at `msapi.tripo3d.ai/mcp` so agents can make models from text/images, refine mesh, texture/UV, rig/animate — all from chat. OAuth sign-in (spends your Studio plan credits, free accounts included). Setup for Codex, Claude Code, Cursor, Manus, any remote MCP+OAuth. Composable with Blender MCP, Roblox MCP. Models don't show in Studio library; download links expire.

### order-flow-mcp — Live crypto order flow via MCP
Launched November 26 (AIToolMaps). Open source MCP server streaming live crypto order flow to agents.

### Agent Garrett — Personal cybersecurity agent
Launched November 26 (AIToolMaps). Pursues data-broker removals, checks suspicious messages, watches websites. Free account + paid plans.

### Stardust (星尘) — Free desktop workbench for multiple coding agents
Launched November 26 (AIToolMaps). Runs Claude, Codex, Gemini, Grok side by side on coding projects. Free downloadable desktop app from GitHub.

### Curio — Design style library as agent-executable spec
Launched November 26 (AIToolMaps). Hands your AI agent a spec to apply to sites, decks, reports. Shifts design systems from human-readable docs to agent-executable specs.

### Black Ghost Argos — Enterprise cybersecurity agent
Launched November 26 (AIToolMaps). Detects, investigates, contains cyberattacks on organization's computers/servers. Full-cycle: detect → investigate → contain.

### Flurra — AI short-video editor with MCP
Launched November 27. Auto-Cut/captions free plus MCP so Claude/ChatGPT can edit/render Flurra projects after OAuth. Free: Auto-Cut + 3×1080p exports/week. Starter $19.99/mo, Spark $39.99/mo, Nova $79.99/mo (20% off annual).

### VibeCode.surf — Desktop editor with lead agent + 6 helpers
Launched November 25 (NewAIToolsToday). Mac/Windows/Linux desktop app where lead agent delegates to up to six helpers that build, run, browser-test your app with your own model keys.

### PeerBand — MCP relay from chat to coding agents
Launched November 25 (NewAIToolsToday). Outbound MCP relay from ChatGPT/Claude/Telegram to coding agents in Herdr: list status, send instructions, share machines, get notes when agent needs you. Free: up to 3 machines. Premium: $5.99/mo + tax for unlimited + AI Concierge.

### Tendeck — Native Mac board for coding agents
Launched November 25 (NewAIToolsToday). Native Mac app (not Electron) for Claude Code/Codex/other CLIs: parallel cards, clean conversation or real terminal, gold "needs you" alerts, optional server engine.

---

## Significant Updates (Already Tracked)

**Anthropic Claude Ship** (Nov 23) — PR review, fixes, approval agents via `/ship` in Claude Code. Beta for Team/Enterprise only. In KB as `anthropic-claude-ship`.

**Cognition Devin Bots** (Nov 17) — Persistent goal-owning agents leading teams of Devin sessions for weeks. In KB as `cognition-devin-bots`.

**PagerDuty Paige SRE Agent** (GA Nov 3, Escalation Policies GA Nov 19, MCP Server GA Nov 23) — Virtual on-call responder. In KB as `pagerduty-paige-sre-agent`.

**Google Genie 4 World Model** (Nov 19) — Continuous 720p @ 24fps with synchronized native audio. In KB as `google-genie-4-world-model`.

**Google Gemini Computer Use (Mac)** (Nov 19) — Gemini app for Mac clicks, types, fills forms. In KB as `google-gemini-computer-use-mac`.

---

## What I'm Seeing

**The orchestration layer is where the differentiation lives now.** Hub (swarm dispatcher), DeskFleet (team coordination), Pax (plugin harness), VibeCode.surf (lead+helpers), Slate V1 (swarm-native from last run) — every new coding agent launch is explicitly about *coordinating multiple workers*, not making one smarter worker. The unit of work has shifted from "one agent, one task" to "one coordinator, many parallel executors."

**MCP is becoming the universal glue.** Canva MCP (GA Nov 25), Cloudflare Search for Agents, Perplexity Time Machine, QA.tech MCP, Tripo Studio MCP, order-flow-mcp, PeerBand (MCP relay), plus every coding agent now shipping MCP support (Pax, DeskFleet, Hub, Koed). The protocol won. The question is no longer "will MCP work?" but "what happens when everything speaks it?"

**Memory and context are the new bottlenecks.** Koed (local-first memory layer), DeskFleet (offline-readable history + cross-machine sync), PeerBand (relay context from chat to agents), Hurdle (eval with context). Everyone hit the "agents rediscover the same decisions every session" wall at the same time.

**Cost collapse at the model layer continues.** GigaChat 4 at 708B/41B active with 1M context open weights (MIT). GigaChat 3.5 Omni multimodal 432B/28B open. Ming-Image 6B design model on single 80GB GPU. Sarvam-105B-1711 at $0.15/M tokens (from last run). You can afford to run frontier-class models in loops now — which is exactly what the swarm/orchestration tools need.

**Agent Experience (AX) is a real category now.** Bifura (how agents read your site), Cloudflare Search for Agents (help bots read correctly), Curio (design specs for agents). The first tools optimizing for *agent consumption* rather than human consumption are shipping.

---

## KB Entities Created/Updated (Nov 25–27)

Created entity cards in `~/Documents/knowledge_bases/ai_tools/entities/`:

- `icons8-hub` (new, Nov 26)
- `pydantic-pax` (new, Nov 26)
- `deskfleet` (new, Nov 27)
- `extraorbital` (new, Nov 26)
- `bifura` (new, Nov 26)
- `gigachat-4` (new, Nov 26)
- `gigachat-3.5-omni` (new, Nov 27)
- `ming-image-0.2-design` (new, Nov 26)
- `koed` (new, Nov 25)
- `hurdle` (new, Nov 25)
- `cloudflare-search-for-agents` (new, Nov 25)
- `perplexity-time-machine` (new, Nov 25)
- `qa-tech-mcp` (new, Nov 27)
- `tripo-studio-mcp` (new, Nov 27)
- `order-flow-mcp` (new, Nov 26)
- `agent-garrett` (new, Nov 26)
- `stardust` (new, Nov 26)
- `curio` (new, Nov 26)
- `black-ghost-argos` (new, Nov 26)
- `flurra` (new, Nov 27)
- `vibecode-surf` (new, Nov 25)
- `peerband` (new, Nov 25)
- `tendeck` (new, Nov 25)