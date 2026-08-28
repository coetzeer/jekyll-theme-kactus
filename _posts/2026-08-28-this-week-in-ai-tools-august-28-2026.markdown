---
layout: post
title: "This Week in AI Tools — August 28, 2026"
date: 2026-08-28 07:10:00 +0200
description: "GLM-5.3-Flash goes open, MCP goes stateless, and Slack turns AI coding multiplayer"
categories: [ai-tools, weekly]
tags: [ai-tools, coding-agents, llm, mcp, cloudflare, slack, open-source]
image: /jekyll-theme-kactus/assets/images/this-week-in-ai-tools-august-28-2026.svg
---

<img src="/jekyll-theme-kactus/assets/images/this-week-in-ai-tools-august-28-2026.svg" alt="This Week in AI Tools — August 28, 2026">

<audio controls src="/jekyll-theme-kactus/assets/images/this-week-in-ai-tools-august-28-2026.mp3" style="width: 100%; margin-top: 20px;">
Your browser does not support the audio element.
</audio>

Zhipu's GLM-5.3-Flash dropped as open weights under MIT this week. The stealth "Ox Alpha" preview we've been hammering for a week is now officially a 320B/18B MoE model with 1M context, native multimodal (text, image, video), and $0.15/$0.50 API pricing. Frontier-class, open, and cheap — a combo we rarely see.

The Model Context Protocol shipped its biggest rewrite yet. MCP 2026-07-28 goes fully stateless. No more held connections, no more session IDs. Servers can now run on Cloudflare Workers, Vercel Edge, Lambda — anywhere HTTP works. The standout is URL-mode elicitation: it lets tools push users to a browser for OAuth, API keys, or payments without secrets ever touching the model context. That's been a gap for a while. Now it's closed.

Cloudflare's Kitesurf launched in early August — a browser built for agents, not humans. Runs in V8 isolates on Workers, 3-7x lighter than Chromium, Puppeteer/Playwright compatible via a single parameter swap. Free in beta. If your agents browse, this matters.

Slack Code went live August 20-21. Dedicated channels where multiple AI agents (Claude Code, Devin, Copilot, Vercel) work alongside your team. Free on all Slack plans; you just bring your own agent subscriptions. Collaborative vibe-coding in the open — planning, review, approval all in-channel.

WarpGrep v2 from Morph hit #1 on SWE-Bench Pro. An RL-trained search subagent that runs as an MCP server inside any agent (Claude Code, Codex, Cursor, etc.). 8 parallel tool calls per turn, ~5s latency, lifts every major model by +2-3.7 points. Free tier: 100k requests.

Google Research open-sourced PaperOrchestra — a multi-agent pipeline that turns rough notes and experimental logs into submission-ready LaTeX manuscripts. Outline agent, plotting agent, literature review agent, section writer, content refiner. arXiv:2604.05018, Apache 2.0.

Quick hits:
- **Cursor Origin** (Aug): Agent-native git forge inside Cursor, mirrors GitHub, stacked PRs, agent-aware merge queues. Beta on Pro/Teams/Enterprise.
- **Harness Code Repository + AI Code Review** (Aug 27): Agent-ready git hosting with AI review that understands risk. Free tier 50GB, MCP/CLI access.
- **Lody** (Aug): Collaborative workspace for coding agents — shared runtime state, conversations, code changes. CLI and desktop client now open source.
- **SonarQube Hunter Agent** (Aug 27, GA): AI security agent for logic flaws — broken access control, business logic, auth issues. 80-90% precision via exploitability validation subagent. Enterprise plan on SonarQube Cloud.

---

### By Category

**Coding Agents**
- WarpGrep v2 (Morph) — RL-trained search subagent, MCP server, commercial with free tier
- Cursor Origin — Agent-native git forge, commercial SaaS
- Harness Code Repository + AI Review — Agent-ready hosting + review, commercial SaaS
- Lody — Shared workspace for agents, open source (MIT)

**Long-Running Agents**
- PaperOrchestra (Google Research) — Multi-agent paper writing, open source (Apache 2.0)
- SonarQube Hunter Agent — Scheduled/on-demand security agent, commercial SaaS

**Other**
- GLM-5.3-Flash (Z.ai) — Open-weight multimodal LLM, MIT license
- MCP 2026-07-28 Spec — Stateless protocol, URL elicitation, open standard
- Cloudflare Kitesurf — Agent-first browser on Workers, commercial SaaS (free beta)
- Slack Code — Collaborative AI coding in Slack, commercial SaaS (free on Slack plans)

---

### What I'm Watching

The GLM-5.3-Flash release is the most interesting to me. An open-weight 320B MoE that activates 18B per token, with native multimodal and 1M context, priced at $0.15/$0.50 — that changes the economics for anyone building on open models. The fact that it was stealth-tested as "Ox Alpha" on OpenRouter for a week before reveal tells you something about how frontier labs are now doing pre-launch validation.

MCP going stateless is the infrastructure story. It unblocks serverless deployment and fixes the OAuth/credential problem properly with URL-mode elicitation. If you're building agent infrastructure, this is the spec to implement.

Slack Code is a UX shift — moving AI coding from terminal/IDE into the team chat. Whether that sticks depends on whether teams actually want to review code in Slack channels or if it's just novelty. The partner lineup (Claude Code, Devin, Copilot, Vercel) is strong.

---

### References

- [Z.ai launches GLM-5.3-Flash (Aug 26, 2026)](https://www.explainx.ai/blog/glm-5-3-flash-ox-alpha-official-launch-august-2026)
- [MCP 2026-07-28 Specification (Jul 28, 2026)](https://blog.modelcontextprotocol.io/posts/2026-07-28/)
- [Cloudflare launches Kitesurf (Aug 6-8, 2026)](https://blog.cloudflare.com/kitesurf/)
- [Slack Code launch (Aug 20-24, 2026)](https://venturebeat.com/orchestration/slack-wants-to-drag-ai-coding-out-of-the-terminal-and-into-the-group-chat)
- [WarpGrep v2 #1 on SWE-Bench Pro (Aug 2026)](https://www.morphllm.com/products/warpgrep)
- [PaperOrchestra: Multi-agent paper writing (Apr 2026)](https://github.com/google-research/paper-orchestra)
- [Cursor Origin: Agent-native git forge (Aug 2026)](https://www.infoq.com/news/2026/08/cursor-origin-alternative-github/)
- [Harness Code Repository + AI Review (Aug 27, 2026)](https://www.prnewswire.com/news-releases/harness-launches-code-repository-with-ai-code-review-for-agent-ready-development-302861964.html)
- [Lody open source (Aug 2026)](https://github.com/lodyai/lody)
- [SonarQube Hunter Agent GA (Aug 27, 2026)](https://www.sonarsource.com/blog/hunter-agent-detects-logical-flaws/)

---

*This post is part of a weekly AI tools roundup. Previous: [This Week in AI Tools — August 27, 2026](https://coetzeer.github.io/jekyll-theme-kactus/2026/08/27/this-week-in-ai-tools-august-27-2026/)*