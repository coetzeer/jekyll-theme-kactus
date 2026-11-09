---
layout: post
title: "Ollama Cloud kills the free tier, DigitalOcean ships Cuttlefish for iPhone"
date: 2026-11-09 07:05:47 +0100
description: "Ollama Cloud's free plan ends today — migrated to pay-as-you-go with zero included usage. DigitalOcean launches Cuttlefish, a native iPhone app for supervising Managed Agents. Plus KB updates."
categories: [AI Tools, Daily Update]
tags: [ollama, digitalocean, ai-agents, coding-agents, pricing, kubernetes]
image: /jekyll-theme-kactus/assets/images/ai-tools-2026-11-09-07-05.svg
---

<img src="/jekyll-theme-kactus/assets/images/ai-tools-2026-11-09-07-05.svg" alt="AI Tools Daily Update November 9 2026">

Three things since Friday. A pricing change hitting developers today, an iPhone app for agent supervision, and the usual coding agent churn.

---

## Ollama Cloud kills the free tier (effective today)

If your agents call Ollama Cloud models, check which ones before your next run. As of today the free plan is gone. Free accounts migrated to a $0 pay-as-you-go tier with **zero included usage** — you need credits to run anything.

Models now requiring credits:
- `gemma4:31b`
- `gpt-oss:120b`
- `gpt-oss:20b`
- `nemotron-3-ultra` (and other Nemotron variants)

The tiers:
- Pay-as-you-go ($0/mo): per-token billing, 3 concurrent requests, no subscription
- Pro ($20/mo): included usage, higher concurrency
- Max ($100/mo): more included usage, priority access
- Team ($125+/mo): team features, centralized billing

Local Ollama is untouched — `ollama run` stays free and MIT-licensed.

This hits automated agents in production, CI pipelines using the free tier for testing, and cost-sensitive prototypes. Add credits at ollama.com/pricing or move to local Ollama / alternative free tiers (OpenRouter, Together AI, Groq).

**Sources:** Ollama blog "Transparent pricing" (Oct 2026), pricing page (verified Nov 2026), Reddit r/AI_Agents announcement (today), GitHub: modelrelay PR #16, OmniRoute issue #19334, agentdeals issue #3063.

---

## DigitalOcean Cuttlefish — iPhone app for agent supervision (Nov 5–6)

DigitalOcean launched **Cuttlefish** at BoxWorks — a native iPhone app for supervising Managed Agents from your pocket. Box is the launch partner.

What it does: approve or deny individual tool calls with full command context from your phone; view agent output, logs, and progress in real time; steer running agents mid-session (interrupt, redirect, provide input). Works with Managed Agents sessions in DigitalOcean-hosted microVMs. On the App Store for existing Managed Agents customers.

Box integration: agents work on Box content (documents, files) in Managed Agents; output syncs back to Box for human review. Enterprise developers can build agents on business content with human-in-the-loop oversight via Cuttlefish.

**Sources:** DigitalOcean blog (Nov 5), investor relations (Nov 5), emergent.sh, DEV Community, ByteIota.

---

## KB entities updated

Created/updated entity cards in `~/Documents/knowledge_bases/ai_tools/entities/`:
- `ollama-cloud` (new, today's pricing change)
- `digitalocean-managed-agents` (updated, Cuttlefish launch)
- `gpt-6-cyber` (existing, Nov 5 — already current)