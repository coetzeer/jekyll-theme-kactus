---
layout: post
title: "AI Tools Update: Cursor Rollouts, JetBrains Air, OpenCode 2.0, and Claude Tag"
date: 2026-09-24 07:00:00 +0200
description: "This week's AI tool releases: Cursor adds deployment and security bots, JetBrains launches Air for agentic development, OpenCode 2.0 goes multi-interface, and Anthropic demos Claude Tag for incident response."
categories: [AI, Tools]
tags: [ai-tools, cursor, jetbrains, opencode, anthropic, agentic-dev]
image: /jekyll-theme-kactus/assets/images/2026-09-24-ai-tools-update.svg
---

<img src="/jekyll-theme-kactus/assets/images/2026-09-24-ai-tools-update.svg" alt="AI Tools Update Banner">

Cursor shipped two bots this week for the last mile of shipping code. Rollouts watches every change as it deploys and reports health per environment. Security Review reads every PR in context and flags exploitable bugs — SQL injection, command injection, auth bypass, that kind of thing. Both are Teams/Enterprise only, enabled from the dashboard. Bugbot still handles style and quality; Security Review is purely about vulnerabilities.

JetBrains went big on September 22 with Air. Not an IDE feature update — a whole "agentic development environment" system. Three connected pieces: Air inside the IDEs (IntelliJ, PyCharm, WebStorm, etc.), JetBrains Central as an open control/execution layer (CLI, shared context, cloud agents, governance, cost controls), and cloud agents for remote execution. They've been publicly experimenting with Central for six months; this brings it together. The pitch: the era of everything fitting in one IDE window is ending, but the IDE still matters for review and debugging.

OpenCode 2.0 beta dropped September 22. Major rewrite: v1 was a standalone TUI; v2 is a single Hono/SQLite server backing three interfaces at once — terminal, Electron desktop app, and web UI. State syncs across all of them. Close the terminal, open the desktop app, pick up where you left. They also ship a documented REST API with SSE and a TypeScript client (`@opencode-ai/client@next`) so you can build your own tooling on top. Free, MIT-licensed, provider-agnostic. 160k+ GitHub stars before v2 even landed.

Anthropic announced Claude Tag via a September 24 webinar. It's "Claude in Slack as a teammate" for incident response. Alert fires → Claude reads logs, repos, runbooks → posts likely causes → drafts the fix as a PR → briefs late joiners → writes the postmortem draft. Humans approve every action. Not autonomous remediation; autonomous investigation with human gates. Setup in one sitting from settings.

S1Code also surfaced on Show HN (Sep 19). A "decision-first" Rust coding agent with deterministic policy, bounded decisions, and optional Jev integration for action selection and context eviction. Sessions persist, evidence survives context eviction, source install only (Rust 1.94, macOS/Linux). Early experimental but the architecture is interesting — models plan and generate, S1Code owns local execution.

That's the week. Cursor hardening the last mile, JetBrains betting the IDE survives as a control surface, OpenCode going multi-interface and API-first, Anthropic putting Claude in the on-call rotation, and a Rust agent rethinking the loop from the ground up.