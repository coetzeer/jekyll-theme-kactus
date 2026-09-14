---
title: "This Week in AI Tools: Persistent Coordinators, Multi-Model Routing, and CI That Finally Works"
date: 2026-09-14 08:00:00 +0200
description: "Cursor Projects launches persistent coordinator agents, GitHub Copilot gets multi-model routing, Open-PR brings review into your CLI, and Claude Code's four-day sprint makes unattended CI reliable."
categories: [ai, devtools, agents]
tags: [cursor, github, copilot, claude-code, open-source, coding-agents, long-running-agents, ci-cd]
layout: post
image: /jekyll-theme-kactus/assets/images/2026-09-14-this-week-in-ai-tools.svg
---

![This week in AI tools — coordinators, routing, and CI](/jekyll-theme-kactus/assets/images/2026-09-14-this-week-in-ai-tools.svg)

Five things dropped since the last run. Four of them shipped this week; the fifth (Claude Code's sprint) landed Sep 2–6 but the practical impact is just now hitting CI runners.

## Cursor Projects: Persistent Coordinator for Agent Fleets

**Launched Sep 10 (beta rolling out).** Michael Truell's "third era" thesis from February — autocomplete → synchronous agents → fleets operating for months with less direction — now has a beta feature attached.

A `Project` is a dedicated cloud computer with a coordinator agent that:
- Plans work, spawns subagents for research/implementation/testing, collects output for review
- Delegates to thousands of subagents (account limits and compute costs not published)
- Survives laptop closure — work continues on the cloud machine
- Can spawn local agents on your machine when a change needs local testing
- Synchronizes plans, demos, research, testing instructions, and lessons across cloud/local
- Watches Slack for bug reports, follows PRs, reacts to CI failures, runs on schedules ("subscriptions")

The SpaceX acquisition (Aug 14) for GPU capacity makes the compute economics plausible. This is the first coordinator I've seen that treats "months of context" as a first-class primitive instead of a workaround.

## GitHub Copilot Project HydraFusion: Multi-Model Routing at Runtime

**Announced Sep 13 (research preview).** GitHub's answer to "which model for this task?" isn't automatic selection anymore — it's orchestration.

HydraFusion builds full execution plans using models from multiple providers: plan with one, implement with another, review with a third. It treats workflow execution as an optimization challenge, not a model-selection problem.

Enable via Copilot CLI: `/experimental on` then select HydraFusion from `/model`. All tiers. Billed at underlying models' standard token rates. Research preview — not GA — but the direction is clear: single-model selection was a stepping stone.

## Open-PR: Code Review Inside Your CLI

**Launched Sep 14 (open source).** Most AI code review runs as a SaaS bot or separate GitHub App. Open-PR runs inside your existing agent CLI — Claude Code, Cursor, Codex, Gemini CLI, Antigravity.

```
/open-pr:review 42   # Get findings
/open-pr:fix 42      # Apply fixes, no force-push, replies on threads
```

Same context, same permissions, same workflow. No separate bot account. The fix command that replies on threads after pushing keeps the review loop in the tool you're already using. Community-driven, not commercial.

## Weftgate 0.2: Local "Second Brain" for Coding Agents

**Released Sep 13 (MIT, Python).** Instead of stuffing more context into the model, give it a local package that handles three jobs: understand (relevant source locations), remember (current decisions), verify (evidence changes connect correctly).

Dual CLI + MCP interface means it works with any agent that speaks MCP. Editor integration writes project config for Codex, Claude Code, Cursor, Antigravity. Completion hooks request bounded repair passes. Pre-edit adapter for Claude Code. GitHub Action for branch protection gating.

The framing is right: agents don't need larger context dumps; they need a small, relevant, verifiable slice.

## Claude Code v2.1.259–2.1.263: Four Days, Unattended CI Finally Works

**Sep 2–6.** Four releases in five days. The `latest` npm tag is 2.1.263; `stable` is still 2.1.236 (27 versions behind — check which tag you actually resolved).

The practical headline: `--permission-prompts none` + `managedMcpServers` = agents that finish instead of hanging on prompts in CI. `/skill-doctor` puts a number on context waste (skills burning tokens without being reached). `/cost` now tells you *why* prompt cache missed (tool definitions changed, system prompt changed, idle past TTL). `bashOutputMaxChars` / `taskOutputMaxChars` up to 128K retires the `head` workaround for clipped output.

If you run agents on schedules or in CI, this sprint matters more than any model release this month.

---

## What I'm Actually Watching

1. **Cursor Projects** — persistent coordinator + thousands of subagents + external triggers is the structural shift. If the compute economics hold, this changes how long-horizon work gets done.
2. **HydraFusion** — GitHub admitting runtime orchestration > single-model selection. Research preview, but the pattern will spread.
3. **Open-PR / Weftgate** — tooling that meets agents where they already live (CLI, MCP) instead of demanding a new platform.
4. **Claude Code's stable/latest gap** — 27 versions of fixes you don't get if you pin stable. Verify your resolved version.

The rest? Noise until proven otherwise.

---

*This post is part of a weekly series tracking AI tooling that ships. No benchmarks were harmed — only vendor claims were cited.*