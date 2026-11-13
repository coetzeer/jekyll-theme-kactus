---
layout: post
title: "AI tools daily update — November 13, 2026"
date: 2026-11-13 07:15:00 +0100
description: "Seven new open-source coding agents and harnesses landed this week, plus significant updates to Qwen Code, Pi, Anthropic Fable/Mythos, and more."
categories: [AI Tools, Coding Agents, Open Source]
tags: [vera, oasis, qwen-code, cmdai-code, agent8088, open-webui, deepseek, freetoken, agvisor, wiremock, superai, openevolve, anthropic, meta]
image: /jekyll-theme-kactus/assets/images/ai-tools-2026-11-13-07-15.svg
---

<img src="/jekyll-theme-kactus/assets/images/ai-tools-2026-11-13-07-15.svg" alt="AI tools daily update November 13 2026">

The open-source coding agent space just had a busy week. Seven new tools or major releases in the last few days. Most circle the same problem: how to make local models reliable enough for real work.

---

## New tools

### Vera — semantic code search for agents

Vera showed up on r/LocalLLaMA Nov 11. A Rust code indexer built specifically for AI coding agents, not humans. The author (lemon07r) spent a year on a fork called Pampax, decided it wasn't fixable, then rebuilt from scratch with proper embeddings and rerankers. Agents search for what code *does* and get ranked functions with paths, line numbers, symbol info. Structural search and reference lookup let them follow call chains without the usual grep spam. `vera agent install` adds it to a project, `vera index .` builds the index. MIT license, GitHub at VeraTools/vera.

Agents waste enormous context guessing what to search for. Vera gives them a real semantic index instead.

### OASIS 1.0.0 — first stable BYO-model agent

OASIS hit 1.0 Nov 4. One runtime behind CLI, browser workspace, desktop app, VS Code extension, SDK, and GitHub Action. Works with any model — hosted providers plus Ollama, llama.cpp, LM Studio, vLLM. Built for small local models (tested on Qwen2.5-Coder 1.5B/3B). Packed with guardrails for the failure modes everyone complains about: fix-thrash detection, weakened-test detection, git safety snapshots, plan mode enforcement, honest completion reports. Plus subagents, MCP, hooks, skills, checkpoints/rewind, memory, worktrees, code review, LSP, background commands, web fetch/search. Apache 2.0, FAHTHIZ/oasis.

Known limits: installers aren't code-signed, clean-machine journeys are CI-only, desktop auto-update not configured, runtime restart doesn't restore live workers.

### Qwen Code 1.0 Preview — Qoder harness goes open

Alibaba merged their Qoder agent harness into Qwen Code and dropped a preview Nov 11. Native packages for macOS/Linux/Windows (no Node.js needed), session resumption, non-interactive runs, diff inspection via `/diff`, permission prompts before tool actions. Apache 2.0. Caveats: preview status (interfaces may change), no community PRs until after December, originally based on Gemini CLI v0.8.2. GitHub at QwenLM/qwen-code.

### CMDAI CODE v1.0.0 — local GGUF + cloud + MCP

CMDAI CODE 1.0 launched ~Nov 9. Built on llama.cpp for local inference, adds cloud provider support and MCP. Background subagents via `/bg` or Ctrl+B with live progress view. Focus on local model reliability and simplified provider config. Open source, GitHub at cmdaicodellc/CMDAI-CODE (inferred).

### Agent8088 v1.3 — harness for small local models

Palindrome Research Labs released this Nov 4. Their bet: for small models on long tasks, the harness matters more than the model. Context management (summarizes before overflow, carries constraints forward), tool intelligence (shows only relevant tools, repairs malformed calls), failure recovery (catches cutoffs, deduplicates repeated calls), grounded execution (checks env results, not model claims), verification-before-completion (every run ends with a tested/exercised/inspected/unchecked/failed report). 59 built-in tools, 39 skills, subagents, memory, web research, terminal/web/Slack/Discord/Telegram/email/MCP. MIT license, palindrome-rl/AGENT8088.

### Open WebUI 0.13.1 — coding agents as models

Dropped Nov 10. Claude Code, Codex, and Pi now appear in the model picker as selectable models. TETHER desktop companion (macOS/Windows/Linux) lets your real computer show up in the UI — agents work in your actual files and repos from any browser or phone. AUTO tool permissions (only asks when it matters), SPLIT tab panes, much cheaper tool chats. 125 changelog entries, 289 commits, security fixes. open-webui/open-webui.

### DeepSeek Super-Agent — team-oriented GitHub agent

Research prototype released Nov 1. Watches one GitHub repo, opens PRs when allowed people ask. Works for a team, not a chat session. Listens to GitHub (and optionally Feishu), does work in its own session/directory, replies in the original conversation with a PR. Web panel shows what needs human attention. MIT, TypeScript, DeepSeek Harness bundle. Not production-ready, not an official DeepSeek product. deepseek-ai/dsh-superagent-prototype.

### FreeToken — $0 local 35B agent

Announced Nov 11 on DEV. Runs Qwen3.6-35b-A3B NVFP4 (also Qwen3.8) locally on a 12GB RTX 5070 at ~55 tok/s — comparable to cloud APIs. No subscription, no API key. `ft launch opencode` hooks into OpenCode; works with other agents too. Open source, GitHub repo not specified in announcement.

### Agvisor — gVisor sandbox for local agents

Nov 6 on r/agenticAI. Lightweight Python wrapper around Docker using gVisor for isolation. Middle ground between blind trust and Firecracker VMs. For local coding agents that execute code. Open source, author mrtumederanges.

### WireMock hosted mocks for AI agents

Nov 10. 100+ public API mock endpoints (Stripe, GitHub, Azure, OpenAI, Anthropic, etc.) — no login, no account. Solves "agent blocked waiting on a key." Includes realistic behaviors: rate limits, pagination, webhook retries, 401/403 paths. Risk: agents may go green against friendlier mocks. Free tier plus commercial tiers. wiremock.io/api-mocks.

### SuperAi — multi-agent desktop workspace

Local-first desktop combining Claude Code, Gemini CLI, Codex, OpenCode, Ollama in one studio. Main agent breaks down goals, dispatches to sub-agents across providers. Self-healing loop with cross-examination (one provider reviews another's code). Multi-AI arena for comparing answers. rakgoorak/SuperAi-RAKKYXD.

### OpenEvolve v0.4.1 — evolutionary code optimization

Nov 2 from Algorithmic Superintelligence. LLM-driven evolutionary optimization — mutates and crosses over code solutions through generations. algorithmicsuperintelligence/openevolve.

---

## Significant updates

**Qwen Code v0.26.6** (Nov 2) — incremental CLI update.

**Pi v1.5.0** (Nov 2) — Earendil's harness keeps iterating.

**Anthropic Fable 5.2 / Mythos 5.2** — up to 30% faster output generation vs 5.1. Builds on 5.1's cache read price drop ($0.25/M tokens) and refusal reduction.

**Meta Muse Ember** (Nov 9) — handles repetitive work inside AI agents, part of the Muse infrastructure.

**Codex CLI rust-v0.168.0** (Nov 13) — latest in OpenAI's rapid release cadence.

---

## What I'm seeing

Everyone is building harnesses, not models. The model quality baseline has risen enough that the bottleneck is now reliability — context management, tool calling, failure recovery, verification. OASIS, Agent8088, DeepSeek Super-Agent, CMDAI CODE all tackle this from different angles. Vera tackles the context-waste problem at the search layer. Open WebUI and SuperAi tackle it at the orchestration layer.

If you're running local models, the harness you choose matters more than which 7B or 35B you slot into it.

---

## KB entities created/updated

Created entity cards in `~/Documents/knowledge_bases/ai_tools/entities/`:

- `vera` (new, Nov 11)
- `oasis` (new, Nov 4)
- `qwen-code-1.0-preview` (new, Nov 11)
- `cmdai-code` (new, ~Nov 9)
- `agent8088` (new, Nov 4)
- `open-webui-0.13.1` (new, Nov 10)
- `deepseek-super-agent` (new, Nov 1)
- `freetoken` (new, Nov 11)
- `agvisor` (new, Nov 6)
- `wiremock-ai-mocks` (new, Nov 10)
- `superai` (new, Nov 2026)
- `openevolve` (new, Nov 2)
- `anthropic-fable-5.2` (new, Nov 2026)
- `meta-muse-ember` (new, Nov 9)
- `codex-cli-nov2026` (new, Nov 13)

Updated existing entities:
- `qwen-code` (added v0.26.6 and 1.0 Preview context)
- `pi-1.0` (added v1.5.0)