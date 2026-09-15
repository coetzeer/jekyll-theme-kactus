---
title: "This Week in AI Tools: Meta Ships a Personal Agent, OpenAI Goes Long, and the Terminal Wars Escalate"
date: 2026-09-15 07:30:00 +0200
description: "Meta's Muse goes mass-market, GPT-6 Astra runs for days, OpenAI drops the Agents API, and a wave of coding agents hit — Kimi K2.7, Muse Code, Kilo JetBrains, Gloo, Lanes, Vincent, Ornith, SWE-2, T1."
categories: [ai, devtools, agents]
tags: [meta, openai, salesforce, kimi, moonshot, cursor, lanes, kilo, gloo, vincent, ornith, cognition, devin, t1, terminal-agents, long-running-agents, coding-agents]
layout: post
image: /jekyll-theme-kactus/assets/images/2026-09-15-this-week-in-ai-tools.svg
---

![This week in AI tools — Meta Muse, GPT-6 Astra, OpenAI Agents API, and the terminal agent surge](/jekyll-theme-kactus/assets/images/2026-09-15-this-week-in-ai-tools.svg)

Two weeks ago I wrote about the terminal agent wars, model routing going free, and computer use hitting GA. Since then the pace hasn't slowed. If anything it accelerated.

The big story this week isn't a single launch. It's that long-running agents — the kind that pursue goals for days without supervision — just became a category with multiple serious entries. At the same time, the coding agent space got crowded fast.

Here's what shipped.

## Long-Running Agents: The Category Arrives

**Meta Muse** (Sep 8) is the first mass-market personal agent from a major tech company. It runs on a dedicated Secure VM with its own browser, connects to your email, calendar, WhatsApp, Spotify, OpenTable, and actually does things — books travel, sells your car, negotiates bills, keeps working after you close the app. Free tier for most use, subscriptions for heavier workloads. Confidential VM (end-to-end encryption even Meta can't access) coming later this year. This matters because it moves "agents that operate software" from developer preview to consumer product.

**GPT-6 Astra** (Sep 7) is OpenAI's answer to the same problem from the model side. It runs unsupervised for days, chooses its own tools (browsers, spreadsheets, document editors), downloads software it decides it needs, recovers from errors, and completes open-ended tasks. One documented run: five days building a personal knowledge system from years of emails, calendar, and contacts. Rolling out across paid ChatGPT plans, API, and AWS. The shift here is from prompting to delegation — you assign an ongoing area of concern (monitor this research, keep the changelog consistent, maintain this customer account) instead of a one-shot task.

**Salesforce Agentforce Long-Horizon Runtime** (Sep 14) brings the same pattern to enterprise. New runtime lets agents pursue goals across days and weeks with durable execution, memory across sessions, and dynamic steering. Seven job-ready agents (Hunter for sales, others for service, commerce, employee experience, back office) connected to Customer 360. 7 billion Agentic Work Units delivered, 3.2B in Q2 alone. This is the enterprise version of what Astra does for consumers.

**OpenAI Agents API** (Sep 10, public beta) is the infrastructure layer. Hosted Codex harness with managed sessions, hosted or BYO sandboxes, MCP support, custom tools, automatic context compaction, subagents. Replaces the Assistants API (sunset Aug 26). If you're building your own long-running agent on OpenAI's stack, this is now the primitive.

## Coding Agents: The Terminal Wars Got Crowded

**Kimi K2.7 Code** (Sep 4) — Moonshot's open-source, coding-focused agentic model. Stronger on real-world long-horizon coding tasks, 30% less thinking-token usage vs K2.6. Weights on Hugging Face, deployment guides included. Kimi Code IDE at kimi.ai/code, API at platform.kimi.ai ($0.19/$0.95/$4.00 per 1M tokens cache hit/miss/output, 262K context). This is the first open-weight model explicitly built for agentic coding workflows end-to-end.

**Muse Code** (Sep 1, out of beta) — Meta's coding platform with a TypeScript SDK wrapping the Muse Session Protocol (open stdio-based, fully local, no server). Workflows engine spins up parallel subagents in isolated git worktrees, watchable from a single control room. Session Rewind, inter-session messaging. Muse Spark 1.3: ~20% fewer tool calls, 25% fewer tokens vs 1.2. Pricing: Contributor tier $0.10/$0.20 per 1M (opts into training), Standard $1.25/$4.25 (no training), monthly subs $5/$15/$50.

**Kilo for JetBrains** (Sep 1) — Native Kotlin plugin turning JetBrains IDEs into a multi-agent control room. Parallel agents in isolated git worktrees, test with your existing Run Configurations, track diffs and PRs from one frame. 600+ models via Kilo credits or BYO keys. Powered by Kilo CLI (same open-source runtime behind CLI, VS Code, cloud). Free plugin, search "Kilo Code" in Settings → Plugins.

**Gloo Code** (Sep 8, out of beta) — Privacy-first coding harness with purpose-built agent-model pairings, fixed predictable pricing, zero-data-retention. Your code doesn't become training material. Terminal and desktop app. Built on Gloo AI Studio. The pitch: stop managing a shifting collection of models and agents, use a product built for outcomes.

**Lanes v0.49** (Sep 8) — Adds GPT-6 Astra to model picker (dynamically queries Codex binary), Codex hooks system for session state/CI/trust, plan mode on issue board (`/plan`), git worktree attachment to issues, PR state visibility after coding stops. Closes the gap between Claude Code and Codex experience in Lanes.

**Vincent v0.8.0** (Sep 2026) — Pushes toward durable workflows. Free chat with Claude, Codex, Cursor each in own git worktree/branch. Chat-to-task handoff preserving worktree, branch, base revision, changes. Parallel agents in task-scoped containers. Direct GitHub PR creation with live CI checks in task workspace. Open source.

**Ornith-1.0** (Jun 21, but relevant now) — Self-improving open-source coding agents via RL. 9B dense (single 80GB GPU), 31B dense, 35B MoE, 397B MoE (post-trained on Gemma 4 and Qwen 3.5). SOTA on Terminal-Bench 2.1, SWE-Bench, NL2Repo, OpenClaw among open models. 256K context, OpenAI-compatible, MIT licensed. Multiple formats (bf16, FP8, GGUF).

**Cognition SWE-2** (Sep 10) — Powers Devin. 50% on FrontierCode 1.1 Main (within 1 point of Fable 5.1, 64% cheaper). Built on Moonshot's Kimi K3 (2.8T params). Medium-effort tier: 58% fewer turns, 81% less cost than previous gen. Devin pricing: Agent Compute Units (~15 min autonomous work each). $2B Series E at $48B valuation (Sep 8).

**T1 Terminal Agent** (Sep 10) — 122B MoE (Qwen3.5-122B-A10B base) trained purely by RL on executed terminal outcomes. 300+ tool-call turns per task. 64% on Terminal-Bench 2.1 (up from 43.8% base), 27.9% on Long-Horizon Terminal Bench (matches Gemini-3.1-Pro), 38% on Terminal-Bench Hard (ahead of DeepSeek-V4-Pro). Weights on Hugging Face. This is RL on execution, not preference — a different path to agent competence.

## What I'm Actually Watching

If I had to bet on what matters in a month:

1. **Long-running agent primitives** — Muse (consumer), Astra (model), Agents API (infra), Agentforce (enterprise) all shipped within weeks. The category exists now.
2. **Open-weight agentic coding models** — Kimi K2.7, Ornith, T1. The terminal bench numbers are converging on frontier closed models.
3. **IDE integration as the control plane** — Kilo JetBrains, Lanes, Cursor Projects. The IDE is becoming the fleet commander.
4. **Privacy as a differentiator** — Gloo's zero-retention, Muse's Secure VM, Confidential VM. Trust is the moat.
5. **RL on execution vs preference** — T1, Ornith, SWE-2's post-training. Verifiable outcomes beat vibe checks.

The noise floor is high. But the signal — agents that actually persist, recover, and complete multi-day work — is finally visible.

---

*This post is part of a weekly series tracking AI tooling that ships. No benchmarks were harmed — only vendor claims were cited.*