---
layout: post
title: "AI Tools Daily Update - 2026-09-04"
date: 2026-09-04 07:14:00 +0200
categories: ai-tools
tags: [cashfree, perplexity, huawei, anthropic, meta, google, coding-agents, long-running-agents]
---

Cashfree Payments pushed Relay to general availability on September 1 — an AI "Super Agent" that runs payment operations for SMBs end to end. Think reconciliation, disputes, chargebacks, settlement monitoring, all handled by 16 specialised sub-agents working in concert. It's the first agentic payment ops platform I've seen targeting small businesses directly; most of this space is still RPA scripts dressed up in marketing. Cashfree's edge is native integration with their own payments stack — the agent has real-time access to gateway data, banking rails, the works. Pricing is bundled into the platform; you'll need to talk to sales.

Perplexity dropped Hybrid Compute for Mac the same day. The pitch: cloud models handle research and reasoning; a local PPLX Qwen 3.8 27B (plus Gemma 4 E4B, Qwen3.6 35B-A3B, and a Perplexity model option) handles anything involving your private files and apps. Zero cloud credits for the local portion. One-click install in the Perplexity Mac app — no Ollama, no runtime wrangling. Apple featured it at the M6 Mac mini launch. If you've been holding back on AI coding assistants because your codebase can't leave your machine, this is the first credible answer.

Huawei Cloud launched CodeArts Agent in Singapore on September 4. Sixteen specialised agents covering the full SDLC, autonomously planning and executing complex, long-duration tasks. The differentiator they're pushing: deep project-level context for legacy codebases, plus enterprise governance (RBAC, audit, compliance). Multi-access — IDE plugins, CLI/TUI, AI-native IDEs. This isn't a Copilot competitor; it's gunning for GitHub Copilot Enterprise and Cursor Enterprise in APAC. Pricing is "contact us."

Anthropic shipped Fable 5.1 and Mythos 5.1 on September 1. The headline is cache reads: now $0.25/M tokens (down from $1.00/M). That's a 75% cut, translating to roughly 25% cheaper for typical workloads and up to 45% for agent-heavy work where cache reads dominate. They also quietly fixed the refusal problem — 85% fewer medical/biology interventions, ~60% fewer cybersecurity flags. That refusal issue has been the single loudest complaint about Claude models; this is the first update that actually addresses it. Enterprise Frontier Safeguards mean your usage data isn't sitting on their servers for 30-day manual review anymore.

Meta released Muse Spark 1.3 on September 2 with a new "contributor tier" — their signal for deeper community involvement beyond drop-the-weights-and-run.

Google's Gemini 3.8 Flash and 3.8 Flash Cyber dropped September 2 (already tracked in the gemini-3.7-flash entity). Third Flash in six weeks. 3.8 Flash beats most larger frontiers on DeepSWE v1.1 at a fraction of the cost; 54.9% on HLE-Verified. Cyber variant does frontier vulnerability detection and automated patching, gated behind the Fairwind Program for government, critical infrastructure, and maintainers. Introductory pricing holds at $0.75/M in / $3.75/M out through year-end.