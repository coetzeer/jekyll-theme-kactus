---
title: "This Week in AI Tools: Agents Get Eyes, Routing Gets Free, and Everyone Wants Your Terminal"
date: 2026-08-22 08:00:00 +0200
description: "A rundown of the AI tooling that actually shipped this week — computer use goes GA, model routers go free, and the terminal agent wars heat up."
categories: [ai, devtools, agents]
tags: [anthropic, deepseek, nvidia, meta, openai, google, xai, ramp, binance, coding-agents, model-routing]
layout: post
image: /jekyll-theme-kactus/assets/images/2026-08-22-this-week-in-ai-tools.svg
---

![This week in AI tools — agents, routers, and terminal wars](/jekyll-theme-kactus/assets/images/2026-08-22-this-week-in-ai-tools.svg)

I almost didn't write this one. The "AI tool of the week" fatigue is real. Every Monday brings a new model, a new benchmark, a new "changes everything" thread. But this week had signal. Not just noise.

Three things happened that I think genuinely matter if you're building with agents.

## The Terminal Agent Wars Got a New Contender

**Droid** (from Factory AI) has been floating around r/vibecoding for a bit. This week it clicked. It's a terminal-native coding agent — think Claude Code, but open source and benchmark-topping on Terminal Bench. People are running it with Neovim + tmux for full agent mode, not just autocomplete.

The fact that **agent-of-empires** exists — a TUI/Web dashboard to manage *multiple* coding agents (Claude Code, OpenCode, Codex, Gemini CLI, Droid, Copilot CLI...) — tells you the ecosystem has hit critical mass. You don't build a multi-agent manager for one tool.

**TrueForge** from TrueFoundry also dropped (MIT licensed). An agent harness pitched as a vendor-neutral alternative to Claude Managed Agents at "half the operating cost." Bring your own keys, run on your infra, avoid platform markups. NetApp and Automatiq are already using it. 1.8k stars in days.

Then there's **cumora** — an agent-first team chat where AI agents are *teammates* with their own DMs, Kanban cards, identity. Built by yetone. 948 stars in 24 hours. It's either the future of small-team workflows or a fascinating experiment that burns out. The design choice — agents as first-class participants, not sidebar chatbots — is the interesting part.

And **Prevail** (GPL-3.0) launched as a local-first "AI council": ask one question, it runs Claude, GPT, Gemini, and local Ollama in parallel, then synthesizes a verdict showing where they disagreed. Plain files. No account. Runs fully offline. Early alpha, but the pattern — multi-model synthesis as default — feels right.

## Computer Use Went GA (And Got a Browser)

Anthropic shipped **Computer Use, Skills API, and Files API** to GA on August 20. Computer use now takes multiple actions per turn. There's a new **Browser Use Tool** that targets page structure (DOM/accessibility) rather than pixels — huge for reliability. Skills API lets you upload versioned skill folders that load on-demand in Claude's sandbox. Files API: 1TB storage, 5x rate limits, auto-expiration.

All three on Claude Platform, Microsoft Foundry, coming to Vertex AI.

This matters because it moves "agents that operate software" from demo to production primitive. The browser tool especially — pixel-based computer use was always brittle. Targeting elements by semantic structure changes the game.

## Model Routing Just Became a Giants' Game

**Stripe bought OpenRouter for $7B+** on August 16. **Ramp launched Router (router.com) for free** on August 20 — their internal gateway pushing 2.75T tokens/month for three years, now open to everyone. One OpenAI-compatible endpoint, automatic routing to cheapest model clearing your quality bar, fallbacks when providers degrade, dashboard with spend/latency/fallback tracking. Free through 2026, $26 credit, US-only for now.

Ramp already sells AI expense management. The gateway is the wedge; the spend data is the prize. OpenRouter just got a very well-funded competitor backed by a company that *understands* the economics of token routing.

If you're paying for API tokens directly in 2026, you're probably leaving money on the table.

## The Model Layer: Speed, Vision, and Local-First

**DeepSeek-V4-Flash-Vision-Exp** (Aug 21): experimental multimodal model adding vision to their bargain agent model. Beats Opus-4.8 on 3 of 11 multimodal agent benchmarks (DeepSWE, Agents' Last Exam, ZeroBench), close on Terminal Bench (83.9 vs 85.0), Toolathlon, Chartography. Same pricing as V4-Flash: $0.22/1M input off-peak. DeepSeek Harness v0.1.1 shipped same day with a critical sandbox escape fix.

**NVIDIA Nemotron 3.5 Lightning** (Aug 11): 30B MoE with 3B active params, built for *long-running agents*. 4x output speed via speculative decoding (MTP baked into training). OpenMDW-1.1 license — weights, data, recipes all open. NeMo Switchyard routes "plans up to frontier, execution down to Lightning." Designed for harnesses like OpenClaw and Hermes Agent.

**Meta Muse Glimmer** (Aug 20): 30B Apache 2.0 model optimized for *always-on local agents*. Runs on a single consumer GPU. llama.cpp, MLX, ExecuTorch, vLLM, SGLang integrations. Partners: Ollama, LM Studio, Unsloth, Together AI, Fireworks, OpenRouter.

**Tencent UI-Mate-27B** (Aug 17): Apache 2.0 computer use agent, 77.0 on OSWorld-Verified (beats Kimi-2.6). One of the few open-weight computer control models.

**Grok 4.6** (Aug 12): xAI's long-running agent focus. Matches GPT-5.6 Sol on Artificial Analysis Intelligence Index. $2/1M in, $6/1M out. In Cursor, Grok Build, API, OpenRouter.

**Gemini 3.7 Flash** (Aug 13): Google's "most intelligent workhorse" for coding/agents. Intro pricing $0.75/1M in, $3.75/1M out (half 3.6 Flash). Powers Gemini Spark (24/7 personal agent). Antigravity expanded to enterprise — VS Code, JetBrains, Zed, desktop app, CLI.

**GPT-5.6 Sol/Luna** (Aug 19): Free users get new default. Plus/Pro get effort slider. Ultrafast tier (Cerebras, 750 tok/sec) invite-only. Codex/Work still on July versions.

**Qwen 3.8**: 8B open model getting love in weekly roundups as a practical local starting point with Unsloth Studio.

## The Consumer/Platform Plays

**ChatGPT Apple Messages Plugin** (Aug 20): Connect Messages inbox, sort/analyze/draft/send texts from ChatGPT. Works with Codex/ChatGPT Work. Runs locally (Full Disk Access). Privacy "somewhat unclear" per TechCrunch.

**Meta AI Mac App** (Aug 20): System-wide dictation + screen context (Muse Spark). Business integrations: Instagram, Facebook, Meta Ads, Google Workspace. Create decks, draft docs, competitor intel. Zuckerberg's "sell agents to businesses" push.

**Binance Agent OS** (Aug 20): AI agents that trade crypto. MCP support. Works with Codex, Claude Code, Cursor. x402 payments, Agentic Wallet for DeFi. Kraken, Coinbase, OKX all shipping similar.

**Ghost in the Droid**: Open-source framework driving real phones (Android ADB, iPhone WebDriverAgent), 62 MCP tools, Vue dashboard, swappable LLMs. Mobile agents are happening.

## What I'm Actually Watching

If I had to bet on what matters in a month:

1. **Model routing** (Router, OpenRouter) — the economics are too compelling to ignore
2. **Local agent models** (Muse Glimmer, Nemotron Lightning, UI-Mate) — always-on agents need local inference
3. **Computer use via browser DOM** (Anthropic's browser tool) — reliability unlocks actual automation
4. **Terminal agent standardization** — Droid, TrueForge, agent-of-empires point to a common harness layer

The rest? Noise until proven otherwise.

What did I miss? Drop a comment or hit me up — I'm @raymondcoetzee on most things.

---

*This post is part of a weekly series tracking AI tooling that ships. No benchmarks were harmed — only vendor claims were cited.*