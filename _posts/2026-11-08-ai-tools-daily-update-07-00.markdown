---
layout: post
title: "AI Tools Daily Update — November 8, 2026"
date: 2026-11-08 07:00:00 +0100
description: "Fifteen things since Monday. Six coding agent updates. Five long-running agent launches. Four infrastructure drops. Here's what actually matters."
categories: [AI Tools Daily]
tags: [ai-tools, coding-agents, long-running-agents, crush, codex, qwen-code, claude-code, opencode, orca, pr-agent, rivet, superplane, hayate, northcua, devvm, inkling, ernie, libghostty, cloudflare, canopy, nvidia, hol-guard]
image: /jekyll-theme-kactus/assets/images/ai-tools-daily-2026-11-08.svg
---

<img src="/jekyll-theme-kactus/assets/images/ai-tools-daily-2026-11-08.svg" alt="AI Tools Daily Update November 8 2026">

Fifteen things since Monday. I've been tracking this space long enough to know when a week is actually busy versus when it just feels busy. This one's the real deal.

---

## The Coding Agent Updates

### Crush 0.100.0 — Subagents Finally Land in a CLI

Crush now runs subagents in the background. You can check on them, send mid-run follow-ups, stop them, or move them to a different model. Sysadmin mode means Crush can run any command on your system — the release notes straight up say "Be careful." New permissions: `permissions safe` marks commands safe for yolo, `permissions block` blocks them completely.

This is the first CLI coding agent with genuine subagent support. It's not just marketing — you can actually spin up a subagent, walk away, and come back to a finished task. The permission granularity matters for teams who can't just yolo everything in production.

**Source:** GitHub release notes

---

### Codex 0.167.0 — Agent Command Center

OpenAI's answer to multi-session management: `codex agents --no-daemon` opens a UI for managing agent sessions. Session picker marks unread results. You can switch between connected backends from the terminal session picker and keep your drafts when switching.

Honestly? Keeping drafts across backend switches is the kind of UX detail that makes me think someone at OpenAI actually uses this thing. Most tools lose your context the moment you switch models.

**Source:** GitHub release notes

---

### Qwen Code 0.26.8 / 0.26.9 — Vision Support and Daemon API

Two releases in two days. 0.26.8: Mods can submit prompts in headless runs, concurrent workspace rewinds. 0.26.9: Daemon API routes for installing large Skill ZIPs by upload or host file path, image input enabled for Llama 4, LLaVA, Pixtral, and other vision models.

Qwen Code is one of the few fully open-source coding agents with first-party vision model support. The daemon API for skill installation makes it viable for team deployments with centralized skill management.

**Source:** GitHub releases

---

### Claude Code 2.1.319 — Background MCP Tasks, Permission Deny Mode, Security Fixes

MCP tool calls now run as background tasks — Claude Code moves them to the background immediately and returns results when finished. New `permissions.denyInsteadOfPrompting` setting: tool calls that would wait on a permission prompt are denied and the turn continues. Fixed a sandbox escape when creating a worktree and a Bash bypass where a crafted environment prefix could hide part of a command from permission checks.

Here's what bugs me: no mention of the User-Agent email leak reported in GitHub issue #107757 (opened Nov 5). As of Nov 7, that issue remained open with 98 comments and no Anthropic staff response. Background MCP tasks are nice, but silence on a privacy bug isn't.

**Source:** GitHub release notes, GitHub issue #107757

---

### OpenCode 2.2.6 — MCP Connection Pooling

Set `pool: true` on an MCP server to share one connection across projects with the same setup — fewer processes, faster starts. `opencode run` now waits for background jobs; caveat: a job that never exits (dev server, file watcher) keeps the run open, so set a timeout on CI jobs.

MCP connection pooling is one of those boring-but-essential features. If you're running multiple projects against the same internal MCP servers, this saves real resources. The background job wait behavior is a breaking change for CI — read the release notes before upgrading.

**Source:** GitHub release notes

---

### Orca 1.4.250 / 1.4.251 — Nested Workers

1.4.250: Chat turns show changed files and line counts with patches inline. 1.4.251: Workers can start their own workers (nested workers), finished workers keep messaging their coordinator, stopping a worker stops its helpers. Default nested worker depth: 4.

Nested workers with coordinator messaging moves Orca closer to genuine multi-agent orchestration — workers can now delegate and coordinate rather than just execute in isolation. The depth limit prevents runaway recursion.

**Source:** GitHub releases

---

### PR-Agent v0.50.0 — Qodo Donates Flagship to Community

Qodo donated PR-Agent to the open-source community. It now sits in its own GitHub org (The-PR-Agent), is community-owned, has its first external maintainer, and is moving to an open-source foundation.

Core tools (single LLM call each, ~30 seconds): `/describe`, `/review`, `/improve`, `/ask`, `/similar_issue`. Works with GitHub, GitLab, Bitbucket, Azure DevOps, Gitea. Models: OpenAI, Anthropic, Google, DeepSeek, Mistral, anything via LiteLLM (including local Ollama). Deployment: CLI, GitHub Action, Docker, webhook. MIT licensed, ~15.5K stars.

A major company donating their flagship open-source product to the community is rare. The single-call architecture makes it fast and cheap, but the README is honest: "AI is not a senior reviewer — single-call reviews can miss context or be wrong."

**Source:** CrazycodersLab, GitHub

---

## Long-Running Agent Launches

### Rivet — Actor Framework for Agents

Rivet Actors are long-lived processes with in-memory state, SQLite database, WebSockets, and scheduling. Claimed specs: 72 KB per Actor, 4.99 ms p99 cold starts. Apache 2.0, 6,668 stars on Nov 6.

A purpose-built actor runtime for AI agents — persistent, stateful, with built-in scheduling and WebSocket communication. If the cold-start numbers hold, it's a compelling foundation for long-running agent fleets.

**Source:** GitHub, Hacker News

---

### SuperPlane 1.0 — Team Orchestration Layer

SuperPlane automates routine AI engineering work and coordinates coding agents from ticket to verified PR. Key differentiator: built for teams, not single users. Provides a "software factory" shared by the entire team with one shared environment (skills, setup, tools, context belong to the team), single set of standards, full visibility into every run.

Workflow: monitors GitHub/issue trackers → assesses if agent can handle → dispatches agent → records run/branch/PR → verifies status checks → failed checks return to agent with output → passing proceeds to human review. Model-agnostic: OpenAI, Anthropic, Google, xAI, DeepSeek, Qwen, Kimi, plus custom models.

Most agent tooling is single-player. SuperPlane explicitly targets the team/organizational layer — shared standards, shared context, shared visibility. That's where the real productivity gains (or governance nightmares) will happen.

**Source:** i-programmer.info

---

### Hayate Agent — Persistent Harness with Cron/Heartbeats

Lightweight persistent agent harness. Each conversation has its own queue, processed in order. Agent keeps working between messages through heartbeats, recurring loops, cron jobs, standing goals. Interfaces: terminal, Matrix rooms/DMs, Hermes-compatible HTTP run API.

Three repos: `core` (product source, main branch = v0.1.143 snapshot), `plugins` (adapters for context, continuation, Matrix gateway, review, dispatcher, subagents, memory — core pins by revision and per-file SHA-256, never fetches at runtime), `deployments` (Docker Compose, K8s examples). Node 24.22.1 LTS recommended, no root required.

Persistent agent harnesses with cron/heartbeat semantics are a different paradigm from request-response CLI agents. The plugin architecture with pinned SHA-256 revisions is a thoughtful supply-chain security choice.

**Source:** Karsten Samaschke blog, GitHub

---

### NorthCUA — Open Computer-Use Agent Suite

Sees your screen, clicks buttons, fills forms, finishes web tasks. Three model sizes on Qwen3.5: Nano (9B), Mini (35B — beats a closed rival on each major benchmark), Pro (397B). Whole release open: weights, training code, docs, Harness execution framework. No hosted demo/API — build it yourself.

Computer-use agents have been dominated by closed systems (Anthropic, OpenAI). NorthCUA is the strongest open-weight contender yet. The 35B Mini beating a closed rival on benchmarks is a meaningful signal if it reproduces.

**Source:** AIWithGhost

---

### devvm — One VM Per Project

"One VM for every project. An isolated sandbox with your project's toolchain, ready for you or a coding agent to start coding." `~/.ssh`, `~/.aws`, `~/Documents` stay out of the VM. Network traffic through allowlist proxy. MIT, 198 stars, 131 points on Hacker News.

Project-scoped VMs with credential isolation and network allowlists are a practical middle ground between "run everything locally and hope" and "heavy cloud sandboxes."

**Source:** GitHub, Hacker News, Munder Difflin

---

## Infrastructure, Models, and Skills

### Inkling 2 Small — Thinking Machines' 594B MoE, Apache 2.0 Planned

594B total params, 17B active, image inputs, variable effort. Currently on Tinker with closed weights; lab says "We intend to make the full weights available under Apache 2.0 next week after external safety testing and red-teaming." Early checkpoints ran on OpenCode as "Fledge-Alpha." 96 points on HN.

Thinking Machines (Mira Murati's lab) shipping a 594B MoE with 17B active and promising Apache 2.0 weights is significant — most labs at this scale keep weights closed. "Variable effort" suggests test-time compute scaling built into the architecture.

**Source:** Thinking Machines blog, Hacker News

---

### ERNIE 5.5 Flash Base — Baidu's 280B MoE Pre-Training Weights

280B total params, 14B active per token, 33.5T tokens training, 1M-token context for fine-tuning/inference. Weights are the pre-training checkpoint (before mid/post-training). 168 points on HN.

A 280B MoE with 1M context from Baidu, released as pre-training weights, gives researchers a clean base for specialization. 14B active params makes it relatively efficient for its scale.

**Source:** Baidu ERNIE release page, Hacker News

---

### Libghostty 1.0 — Stable Terminal Library

libghostty-vt 1.0: library and C ABI now stable. "Agentic" coding tools like herdr and cmux are built on it. 340 points on HN.

A stable terminal emulation library with stable C ABI is foundational for tools that drive terminals programmatically — including AI coding agents in terminal UIs.

**Source:** Mitchell Hashimoto blog, Hacker News

---

### Cloudflare Security Audit Skill — Verification-Loop Security Review

Coding-agent skill for multi-phase security audits with independently verified, machine-readable findings. Six phases; each unique candidate goes to a fresh verifier that tries to disprove it. "The skill that seeded Cloudflare's vulnerability discovery harness." MIT, 64K stars, 2.5K in one day.

Most security skills just run a scanner. This builds a verification loop — each finding gets a dedicated disproof attempt. Different approach to reducing false positives in AI-assisted security review.

**Source:** GitHub, Munder Difflin

---

### Canopy — Progressive Discovery for Skills/MCP

Self-hosted progressive discovery: one search across skills, plugins, MCP tools, so nothing loads until needed. Bundling (everything together), thin clients (one connector, no credentials on device), context efficiency (agents load what they need, when they need it). Ships no content — you bring your own plugin marketplaces (git repos) and MCP servers. Docker Compose v2 install.

Benchmarks (author's live deployment, ~4,800 records, 49 hard queries): right skill first 44/49 times, top-3 49/49 times, median search 524ms, median cost 312 tokens. MIT, extends MCPJungle.

The context-window explosion from loading all skills/MCP tools upfront is a real problem. Canopy's progressive discovery — search first, load only matches — is the right architectural answer.

**Source:** Daniel Rosehill blog, GitHub

---

### Auto Ontology (NVIDIA) — Enterprise Context Layer via MCP

Builds a context layer from enterprise metadata and serves it to any agent harness through MCP, CLI, and API. "Currently not accepting external contributions." Apache 2.0, 9.2K stars, 2K in one day.

Enterprise context — schemas, APIs, docs, conventions — is the missing piece for making agents useful inside large orgs. NVIDIA building this as an MCP-served layer means it plugs into any MCP-compatible agent. The "not accepting contributions" note suggests it's an internal tool they've open-sourced.

**Source:** GitHub, Munder Difflin

---

### HOL Guard — Ask-Before-Run for Coding Agents

Runs locally next to AI coding agents (Claude Code, Codex, Cursor, Copilot CLI, Cline, Gemini CLI, others) and stops risky shell commands, secret reads, MCP calls, package installs until you approve. Protects: shell/file access, package installs (supply-chain intelligence), MCP servers/tools, plugins/skills/config, prompts/results (prompt injection screening). Decisions: allow, block, ask. `pipx install hol-guard` then `hol-guard init`. Apache-2.0. Optional Guard Cloud for teams. Python 3.10+. "A scan is not a safety guarantee."

Every coding agent can run arbitrary shell commands. HOL Guard adds the missing "ask before you leap" layer locally, no vendor lock-in. Supply-chain intelligence on package installs is a nice touch beyond simple command filtering.

**Source:** Amplibee, hol.org/guard

---

## What I'm Actually Watching

The pace hasn't slowed. Coding agents are converging on subagents, background MCP, and permission granularity. Long-running agent infrastructure is maturing — actor frameworks, persistent harnesses, team orchestration layers, project VMs. Open computer-use agents finally have a credible contender. And the skill/MCP ecosystem is building its own discovery and verification layers.

If you're running agents in production, the Crush subagents, OpenCode MCP pooling, and HOL Guard are the practical picks this week. If you're building agent infrastructure, Rivet, SuperPlane, and Canopy are worth a deeper look. And if you've been waiting for an open computer-use agent you can actually run, NorthCUA is the one to test.

**Sources:** Munder Difflin Agent Tools Today (Nov 5-7), GitHub releases, Hacker News, vendor blogs, CrazycodersLab, AIWithGhost, i-programmer.info, Amplibee, Daniel Rosehill blog, Karsten Samaschke blog, Thinking Machines blog, Baidu ERNIE release, Mitchell Hashimoto blog.