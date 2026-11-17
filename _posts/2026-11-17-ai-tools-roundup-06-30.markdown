---
layout: post
title: "AI Tools Roundup: What Actually Shipped Since Last Time"
date: 2026-11-17 06:30:00 +0100
description: "Six genuinely new entries for the AI tools knowledge base — Mistral's Le Chonk, Z.ai's phone agent, Google's Antigravity, Replit Agent 3, plus major Codex and Claude Code updates."
categories: [AI, Tools]
tags: [AI-agents, coding-agents, open-weights, Mistral, Z.ai, Google, Replit, OpenAI, Anthropic, Notion]
image: /jekyll-theme-kactus/assets/images/2026-11-17-ai-tools-roundup-06-30.svg
---

<img src="/jekyll-theme-kactus/assets/images/2026-11-17-ai-tools-roundup-06-30.svg" alt="AI Tools Roundup November 2026">

## The KB was collecting dust

Last run, the knowledge base sat at 21 entries. Most dated to early November. Since then, a handful of genuinely new tools landed — not version bumps, new categories. Here's what got added.

## Coding agents

### Mistral Large 4 "Le Chonk" (open weights, Oct 29)

A 1-trillion-parameter MoE model (52B active) that Mistral calls the best open-weight model for agentic coding. Independent benchmarks mostly agree: it ties GLM-5.3 on Artificial Analysis's Coding Agent Index (48% vs 49%) while using 47% fewer tokens per task. On Terminal-Bench 4.0 it hits 41% — up 13 points from the preview three weeks earlier — and leads open models on Cognition's FrontierCode 2.0 at 19.7%. Three reasoning modes (low/medium/high) let you trade depth for speed and cost. API pricing is aggressive: $0.70/M input, $2.10/M output. Weights on Hugging Face under a modified MIT license that restricts Model-as-a-Service commercial use.

This is the first Western open model that genuinely competes with the Chinese leaders (DeepSeek V4.1, GLM-5.3) on coding-specific agent benchmarks, not just chat. The token efficiency is the real story — sophisticated agents become economical to run at scale.

### Google Antigravity IDE (free preview, Nov 2025 →)

Google's agent-first platform now exists in two forms: Antigravity 2.0 (standalone desktop app, no IDE, pure agent orchestration) and Antigravity IDE (AI-powered editor with side-panel agent). Both run on Gemini models. The 2.0 app introduces concepts that feel like the next step past Claude Code: dynamic subagents that spawn in parallel, async task management so the main agent isn't blocked, scheduled/cron agent invocation via `/schedule`, JSON hooks to intercept behavior, and project-based (not repo-based) organization. Voice input with live transcription. Slash commands for `/goal`, `/grill-me`, `/browser`, `/swarm`. Rapid monthly releases — v2.32.0 (Nov 13) added Dynamic Workflows for orchestrating parallel subagents in Python, Everforest themes, prompt navigation. Free preview with generous Gemini 3 Pro limits.

### Replit Agent 3 (Jan 2026)

200-minute autonomous runtime — 10x the previous version. The headline feature is a self-testing browser loop: the agent opens the app it just built, clicks around, detects broken flows, and attempts fixes automatically. Replit claims 3x faster and 10x more cost-effective than Computer Use models. 50+ languages, built-in hosting/database/deploy, one-click to Replit Apps. They dropped the free "Assistant" tier in January; Agent 3 is credit-only. $250M raise at $3B valuation same month. Reviews are mixed on cost predictability for complex tasks, but the autonomy ceiling is genuinely higher.

### OpenAI Codex CLI (Nov 2026 updates)

The open-source terminal agent shipped 8 releases in 30 days. v0.164.0 added an agent command center, side-conversation pane, 10 preset slots for prompts/models/permissions, and inline image preview in the terminal. v0.167.0 added draft-preserving backend switching and unread result markers. Daybreak (fast mode) now enabled by default. GPT-6.1 Terra support. Persistent WebSocket cuts round-trip overhead 80%. OpenAI is positioning Codex as the hackable, open alternative to commercial IDE forks — free CLI, pay-per-token API.

### Anthropic Claude Code (Q1 2026 feature wave)

45+ features in 90 days. The big ones: Auto Mode (fewer permission prompts, more autonomy), Background Subagents (parallel workers that don't clutter your main session), Remote Control from mobile (monitor/direct your laptop session from your phone), Channels (MCP-based Telegram/Discord integration), Voice Mode (push-to-talk, 20+ languages), Inline Visualizations (interactive charts/diagrams in responses), Scheduled/Recurring Tasks, 128K max output tokens on Opus 4.6, free code execution with web tools, US-only inference for compliance, persistent memory across sessions. Opus 4.5 (Nov 2025) and 4.6 (Feb 2026) reclaimed the coding leaderboard top spot. Version 2.1.325 (Nov 2026) adds experimental Code Mode and plugin validation.

## Long-running agents

### Z.ai Open-AutoGLM (open source, Dec 8 2025)

The first open-source framework with full "Phone Use" capabilities. A 9B multimodal model (AutoGLM-Phone-9B + Multilingual variant) controls real Android/HarmonyOS devices via ADB/HDC — sees the screen via screenshots, plans actions (tap, swipe, type, launch), executes, loops until done. Supports 50+ Android apps (WeChat, Taobao, Meituan, Douyin...) and 60+ HarmonyOS apps. Built-in safety: confirmation prompts for sensitive ops, human takeover for logins/CAPTCHAs. Remote Wi-Fi control. Local deployment (vLLM/SGLang) or hosted APIs. 23.5k GitHub stars in weeks. MIT/Apache-2.0 licenses. This is a new category entirely — not a coding agent, not a desktop agent, but a phone agent. Z.ai's stated goal: prevent a handful of manufacturers from monopolizing "Phone Use" capabilities.

### Notion Custom Agents (Feb 24 2026)

Native agents inside Notion workspaces with read/write access to pages and databases, plus MCP integrations (Slack, Linear, Figma, HubSpot). Workspace-scoped permissions, admin controls, audit logs. No-code builder for non-technical users. Differentiates by being workspace-native rather than code-first — the agent lives where the knowledge lives. Early stage; depth of capabilities still evolving compared to coding agents.

## What didn't make the cut

Several model releases (GPT-5.4, Gemini 3 Pro, Claude Opus 4.8) — they're model upgrades, not new tools. The KB tracks tools and platforms, not model versions. Cursor, Windsurf, Bolt.new, Lovable — already in the KB from earlier rounds. Devin, OpenHands, SWE-agent — already tracked.

## What I'm watching

Three things stand out this cycle:

1. **Open weights are catching up on coding-specific agent benchmarks** — Mistral Le Chonk is the proof. The gap between open and closed on *agentic coding* is narrowing faster than on general reasoning.

2. **The terminal agent war is settling into distinct lanes** — Codex (open, hackable, terminal-native), Claude Code (feature velocity, commercial, integrated ecosystem), Antigravity (agent-first, async, project-oriented). They're not converging.

3. **New form factors are emerging** — Phone agents (Open-AutoGLM), workspace-native agents (Notion), scheduled/async agents (Antigravity 2.0, Claude Code Cowork). The "chatbot with tools" model is fracturing.

---

*KB now at 27 entities. Next run: watching for OpenAI's GPT-6 Astra agent features, Anthropic's Managed Agents GA, and whether Mistral's reasoning efficiency gains hold on real workloads.*