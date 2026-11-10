---
layout: post
title: "Ripple-65B and Tessera-27B drop, Spacefast launches, Thrum coordinates agents across tools"
date: 2026-11-10 07:05:47 +0100
description: "Two open-weight coding models (Ripple-65B, Tessera-27B-CJK-RL), three long-running agent platforms (Kimi Hosted, Perplexity Teammates, Baseten Sandboxes), Google Cloud Agent Engine, Kiro Crew, Automattic's Spacefast deployment platform, and Thrum's cross-agent coordination layer. Plus KB updates."
categories: [AI Tools, Daily Update]
tags: [coding-agents, long-running-agents, open-source, saas, deployment, coordination, benchmarks]
image: /jekyll-theme-kactus/assets/images/ai-tools-2026-11-10-07-05.svg
---

<img src="/jekyll-theme-kactus/assets/images/ai-tools-2026-11-10-07-05.svg" alt="AI Tools Daily Update November 10 2026">

Ten things since yesterday. Two open-weight coding models dropped, three long-running agent platforms launched, Automattic shipped a deployment service, and someone finally built a coordination layer that works across coding agents.

---

## Ripple-65B Preview — Recursive Intelligence's Dense Coding Model (Nov 4)

Recursive Intelligence dropped a 65B dense transformer for agentic coding. Pretrained from scratch on 12T tokens (Olmo 3 roots), 80 layers, 1M context. Apache 2.0. TerminalBench 2.1: 80.52 — beats Beam-501B (80.1) and Muse Spark Open-816B (76.4) despite being 8-15x smaller. NVFP4 quantization hits 57 GB, fits a DGX Spark or MacBook Pro. $32M total R&D (about 1/10th typical frontier model cost). Available on Hugging Face, Together AI, GMI Cloud, OpenRouter, Fireworks.

This matters because it proves dense models can still compete with MoE at coding, and the cost structure changes what's possible for smaller teams.

**Sources:** Ricursive blog, Hugging Face, Azalia Mirhoseini X post (Nov 4), MindStudio hands-on (Nov 5), GIGAZINE (Nov 8).

---

## Tessera-27B-B-CJK-RL — ZelligeAI's RL Coding Agent (Nov 9–10)

RL-enhanced version of their Qwen3.8-27B coding agent. Thinks in compressed CJK shorthand (English, Chinese words, symbols mixed) using fewer thinking tokens per turn. Rank-32 LoRA on Tinker. Apache 2.0. GGUF and NVFP4 quantized variants on Hugging Face. Built for agentic coding specifically, not general reasoning.

**Sources:** Hugging Face (ZelligeAI/Tessera-27B-B-CJK-RL), Zellige research page, r/LocalLLaMA announcement (today).

---

## Spacefast — Automattic's Agent-Agnostic Deployment Platform (Nov 9)

Automattic spun out Spacefast to handle the infra side of vibe-coded apps. Databases, auth, file uploads, email, analytics — all the boring stuff after an agent builds a working prototype. Works with *any* agent: ChatGPT, Claude, Hermes, OpenClaw, Grok Bot, Muse, Pi, Cursor, OpenCode, Amp, or a Git repo. CLI: `npx spacefast publish`. Approval gates for rollbacks and DNS changes. Collaboration via comments fed back to the agent. Free personal plan; charges for infrastructure, not AI credits. Competes with Lovable and Emergent but doesn't lock you to their agent.

**Sources:** Automattic blog (Nov 9), TechCrunch (Nov 9), PRNewswire (Nov 9).

---

## Kimi Hosted Agents — Moonshot's Managed Long-Running Runtime (Nov 5)

Formal launch of their hosted agent harness (beta since Sept). 140+ skills, 30+ plugins. Isolated cloud sandboxes with state persistence. Web console, REST API, CLI (kha). Event stream with Last-Event-ID resumption. Custom tools run on your side. Usage-based pricing (sandbox hours, inference, plugins). Targets internal monitoring, ops response, investment research, customer service.

**Sources:** Unite.AI (Nov 5), DEV Community, tech360.tv.

---

## Perplexity Teammates — Always-On Enterprise Agents (Nov 4)

Persistent agents that own ongoing work, not just answer queries. Max plan only ($200/mo). Slack integration (assign tasks, get updates), GitHub/Gmail with permission controls. Multi-agent handoffs. Runs on Perplexity Computer platform. iOS coming.

**Sources:** Pulse2 (Nov 4), i10x.ai (Nov 6).

---

## Thrum — Git-Backed Coordination for Coding Agents (Nov 10)

Open source (MIT) messaging layer so Claude Code, Codex, Cursor, and OpenCode agents can talk to each other across sessions, worktrees, machines. Coordinator agent plans, dispatches, reviews. Web UI with live terminal view, threaded inbox. Telegram bridge. Git or Tailscale sync. Free tier (no account); Pro $15/mo ($120/yr) for web UI messaging, agent memory, Conversation tab.

This solves the "agents can't coordinate across tools" problem without forcing a single framework.

**Sources:** thrum.team, GitHub (leonletto/thrum), Get Ready For Agents brief (today).

---

## Baseten Sandboxes — Stateful MicroVMs for Agents (Nov 5)

MicroVM environments that preserve filesystem, memory, running processes. Instant suspend/resume (25ms). Scales to zero when idle. 10 concurrent/org default. Free until Nov 16. First piece of Baseten's agent cloud (Agent Drive storage, Agent Proxy networking coming). Hardware-level isolation.

**Sources:** Baseten blog (Nov 5), docs.baseten.co.

---

## Google Cloud Agent Compute Engine — Gemini-Scale Agent Infra (Nov 6)

Per-agent microVMs based on the infrastructure running Gemini. Governance framework: Agent Gateway (policy), Agent Registry, Agent Identity, OpenTelemetry observability. Cross-cloud/hybrid enforcement via Envoy. Local governance for endpoint coding agents. L'Oréal using internally.

**Sources:** IT Brief (Nov 6), Security Brief (Nov 6).

---

## Kiro Crew — Continuous Autonomous Dev Bots (Nov 6)

GA launch. Bots coordinate multiple agents, maintain project knowledge, run recurring tasks autonomously. Each bot has its own memory. Permission-scoped actions. Techzine coverage.

**Sources:** Techzine (Nov 6).

---

## LazyAI — Tokyo ITSM Agent Platform (Nov 9)

¥100M (~$631K) seed from JAFCO. Automates account provisioning, permission changes, device management across Microsoft 365/Entra ID. Patent on cross-system state verification (2026-236817). Targeting SOC 2, then HR/finance/general affairs.

**Sources:** Dealroom (Nov 9).

---

## Agent Index Benchmark — New Composite Ranking (Nov 9)

26 models ranked on 7 benchmarks (browsing, terminal, coding, docs, spreadsheets, multi-step, reasoning). Top 5: Claude Opus 5.5 (90.4), GPT-6 Astra (87.6), Claude Sonnet 5.5 (85.8), Claude Fable 5.1 (85.7), GPT-6.1 Sol (83.4). Curated published evals, not self-run.

**Sources:** r/AI_Agents post (today).

---

## KB entities updated

Created/updated entity cards in `~/Documents/knowledge_bases/ai_tools/entities/`:
- `ripple-65b-preview` (new, Nov 4 release)
- `tessera-27b-cjk-rl` (new, Nov 9–10 release)
- `spacefast` (new, Nov 9 launch)
- `kimi-hosted-agents` (new, Nov 5 formal launch)
- `perplexity-teammates` (new, Nov 4 launch)
- `thrum` (new, Nov 10 announcement)
- `baseten-sandboxes` (new, Nov 5 launch)
- `google-cloud-agent-engine` (new, Nov 6 launch)
- `kiro-crew` (new, Nov 6 GA)
- `lazyai` (new, Nov 9 funding)
- `ollama-cloud` (existing, Nov 9 pricing change — already current)
- `digitalocean-managed-agents` (existing, Nov 5 Cuttlefish — already current)