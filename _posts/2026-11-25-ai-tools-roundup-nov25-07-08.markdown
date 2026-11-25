---
layout: post
title: "Six tools in four days"
date: 2026-11-25 07:08:34 +0100
description: "Tether 0.4.0, Meta AgentBox, WP Engine Coworker, Tigerless Lara, Tencent Hy-MT3, and Meta Muse UK launch — the AI tools that shipped Nov 22–25."
categories: [AI, Tools, Agents]
tags: [coding-agents, long-running-agents, open-source, commercial, translation, consumer-ai]
image: /jekyll-theme-kactus/assets/images/ai-tools-roundup-nov25.svg
---

<img src="/jekyll-theme-kactus/assets/images/ai-tools-roundup-nov25.svg" alt="Six tools in four days - AI tools roundup Nov 22-25, 2026">

Six tools dropped in four days. Nov 22-25. None of them small.

**Tether 0.4.0 (Nov 22)** — Open source harness from chizy7/agentrebench. The thing that matters: deterministic test replays. Record an agent run, then assert which tools fired, what files changed, whether step or cost limits held. Policy layer, sandbox, replayable trace — one package. Apache 2.0. If you run agents in CI, this solves the "how do I test non-deterministic code" problem.

**Meta AgentBox (Nov 25)** — Not the Marco D'Alia project. Meta FAIR's HPC orchestrator. Runs agent containers via Apptainer on local Linux or Slurm, no root. Monarch coordinates multi-agent work. The `wait_for_workers()` call makes queue time explicit — evals fail fast instead of silently degrading. Apache 2.0, Python 3.12+, macOS via Lima. README says "under construction" but the Slurm API works.

**WP Engine Coworker (Nov 23)** — AI agent baked into WP Engine's hosting. Handles WordPress ops in plain language: content edits, audits, SEO rewrites, multi-site workflows. Human approval before anything goes live. Auto restore points. Works in User Portal, WP Admin, MCP (Cursor, Claude Desktop). Free beta for customers with unified AI credits. Permission model (Read/Draft/Execute) is smart — execute stays rare by design.

**Tigerless Lara (Nov 24)** — Enterprise agent from a licensed insurance operator (136 countries, since 2018). "Hired, not integrated" — joins your Slack/Teams, learns workflows autonomously, hands back finished work. Permissions enforced by tools, not agent judgment. Customer owns all memory/skills/integrations; portable via MCP. Tigerless Labs open-sources the infra. Early access at golara.ai. No pricing. SPAC merger with PVAC.

**Tencent Hy-MT3 (Nov 24)** — 102-language translation family, three sizes (1.8B, 7B, 30B-A3B MoE), Apache 2.0 with FP8 and GGUF. The 30B-A3B hits 45.73 on VISTA-Bench text, beating Gemma4-26B-A4B and Index-Translate-35B-A3B. Ships TransRubric — rubric-based eval that beats COMET/BLEU on WMT26 and aligns better with human judgment. Strong on image translation (OCR error tolerance) and game localization. Runs locally via llama.cpp.

**Meta Muse UK launch (Nov 23)** — First Big Tech consumer agent in the UK. Adults 18+ on iOS, Android, muse.ai, WhatsApp. Free tier + subs. Powered by Muse Spark 1.3. Does Christmas shopping, energy comparisons, travel from Reels. UK partners: M&S, Currys, Sainsbury's, easyJet, Trainline, Argos, ASOS, Jet2, Ocado, Debenhams, LOOKFANTASTIC, MyProtein, JustPark, JD Sports + global (Spotify, OpenTable). You approve every purchase/email. Separate security agent. Credentials isolated. Regulators (CMA, ICO, FCA, Ofcom) watching. BBC reviewer called it "helpful but awkward" — proactive to a fault. Meta's $145B AI bet; Muse is their WhatsApp-for-agents play. Walmart US uses Muse as first shopping agent.

The thread connecting them: agents moving from "impressive demo" to "thing you can test, deploy, or buy." Tether gives testability. AgentBox gives HPC infrastructure. Coworker gives hosted SaaS with guardrails. Lara gives an enterprise teammate with ownership guarantees. Hy-MT3 gives a translation backbone you self-host. Muse gives consumers a delegate that does stuff — with regulators breathing down its neck.

Six months ago these were research prototypes. Now they ship with licenses, pricing, compliance, eval frameworks. That's the shift.