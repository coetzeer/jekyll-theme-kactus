---
layout: post
title: "This Week in AI Tools: August 27, 2026"
date: 2026-08-27 07:10:51 +0200
description: "Cloudflare Kitesurf browser for agents, Slack Code collaborative coding channels, WarpGrep v2 MCP search subagent, PaperOrchestra multi-agent paper writer, MCP 2026 spec final — plus the patterns reshaping agent infrastructure."
categories: [ai, tools, coding-agents]
tags: [ai, coding-agents, open-source, cloudflare, slack, warpgrep, mcp, paperorchestra, nemotron, qwen]
image: /jekyll-theme-kactus/assets/images/ai-tools-weekly-2026-08-27.svg
---

<audio controls src="/jekyll-theme-kactus/assets/images/ai-tools-weekly-2026-08-27.mp3" style="width: 100%; margin-top: 20px;">
Your browser does not support the audio element.
</audio>

This week feels different. Not "the landscape shifted" different — actually different. Multiple new paradigms landed at once, and they're not models. They're the runtimes, protocols, and collaboration surfaces agents will actually live in.

## New tools worth your attention

### Cloudflare Kitesurf (Free beta, commercial SaaS)
A stateless, cloud-hosted browser built specifically for AI agents. Runs entirely on Cloudflare Workers using V8 isolates — no Chromium underneath. Written in Rust with WebAssembly and Dioxus Blitz. Uses 3-7x less CPU/memory than Chromium, spins up per request, passes 235k+ web platform tests. Drop-in for Puppeteer/Playwright: add `browser=kitesurf` to existing code. Free during beta via Browser Run.

**Category:** Other (Browser runtime) | **Type:** Commercial SaaS (free beta)

### Slack Code (Free on all plans, agents need partner subs)
Collaborative AI coding channels where multiple agents (Claude Code, Devin, GitHub Copilot, Vercel) work alongside your team in shared Slack channels. Plan tasks, review generated code, approve PRs together. GitHub is a launch partner — Copilot cloud agent now works from Slack DMs and threads. OpenAI ChatGPT coming soon.

**Category:** Other (Collaboration platform) | **Type:** Commercial SaaS (freemium)

### WarpGrep v2 (Free 100k req, then commercial)
RL-trained parallel code search subagent that lifts every major model to #1 on SWE-Bench Pro (+2.1 to +3.7 points). Works as an MCP server (@morphllm/morphmcp) in any agent — Claude Code, Codex, Cursor, OpenClaw, Hermes. 8 parallel tool calls, ~5s median latency, 15.6% cheaper, 28% faster, 13% fewer turns. Three tools: codebase_search, github_codebase_search, edit_file (opt-in).

**Category:** Coding agent (MCP subagent) | **Type:** Commercial (Morph)

### PaperOrchestra (Open source, Apache 2.0)
Google Research's multi-agent framework that turns rough idea summaries + raw experimental logs into submission-ready LaTeX manuscripts. Handles literature synthesis, experiment description, full paper structure. Unlike AI Scientist-v2, it works with your materials — no experiment execution needed. Works with any coding agent via skills/benchmark.

**Category:** Other (Research automation) | **Type:** Open source

### MCP 2026-07-28 Spec (Open protocol)
Major revision: dropped protocol-level sessions (stateless), added URL Elicitation for OAuth mid-call, hardened authorization (OAuth 2.1 resource servers, RFC 8707 resource indicators), progressive discovery for servers with 20+ tools. Agent identity and long-running task primitives on the roadmap. Migration deadline was July 28.

**Category:** Other (Protocol infrastructure) | **Type:** Open standard

### Nemotron 3.5 Lightning + NeMo Switchyard (Already in KB, worth re-highlighting)
30B MoE with 3B active params, 4x output speed, 1M context, speculative decoding baked in. NeMo Switchyard routes each agent request to the right model — 74% cost reduction in LangChain benchmarks, only 7% calls to frontier models. Both Apache 2.0 / OpenMDW-1.1.

## Major platform moves

### GitHub Copilot in Slack (Public preview, Aug 21)
Full cloud agent sessions from Slack: investigate issues, plan changes, write code, create PRs. Included in GitHub app for Slack. Sandbox billing applies during preview.

### Qwen3.8-27B and Qwen3-Coder-Next (Open weights, Apache 2.0)
Qwen3.8-27B: 27B dense multimodal, vision-language, flexible thinking, ~33 tok/s on Apple Silicon MLX. Qwen3-Coder-Next: hybrid attention-MoE for coding agents. Both dropped mid-August. Qwen 3.7 was skipped entirely.

## Patterns solidifying

**Background/daemon sessions are table stakes.** Prime Agent, Shofer, Mastra Code, Claude Code — they all run while you're not watching.

**Agent teams moving to production.** Claude Code's agent teams, Muse Code's persistent subagents. The "single agent" model is fading.

**Model routing is the new infrastructure layer.** NeMo Switchyard, OpenRouter, BYO model — sending each task to the right model saves 70%+ on tokens.

**IDE integration depth is the platform play.** Zed (native), coral-code (JetBrains PSI), Cursor (Origin hosting), Zide (unified workspace) — they're not editor plugins anymore.

**MCP is becoming the universal agent interface.** URL Elicitation solves OAuth. WarpGrep, Kitesurf, Mobile-MCP, Copilot Slack all speak MCP. The 2026 spec makes it stateless and enterprise-ready.

**Open velocity remains surprising.** Qwen3.8, Qwen-Coder, Mobile-MCP, NeMo Switchyard, PaperOrchestra — all open, all dropped in weeks.

---

*Sources: Cloudflare blog, Salesforce press release, Morph blog/YC launch, Google Research arXiv:2604.05018, MCP blog, aiagentstore.ai daily updates, GitHub changelog, Qwen Hugging Face releases, NVIDIA developer blog.*