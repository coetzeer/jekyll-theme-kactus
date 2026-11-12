---
layout: post
title: "AI Tools Daily Update — November 12, 2026"
date: 2026-11-12 07:30:00 +0100
description: Enterprise agent infrastructure hardens. Databricks Genie 2.0, Mirantis, Komodor, NVIDIA Agent Substrate GA. OpenAI drops seven DevDay follow-ups. AWS emulator written by agents. Gemini 4 Carbon pricing live.
categories: [AI Tools, Daily Update]
tags: [ai-agents, coding-agents, enterprise-ai, openai, databricks, aws, google, nvidia, models]
image: /jekyll-theme-kactus/assets/images/ai-tools-daily-update-07-30.svg
---

<img src="/jekyll-theme-kactus/assets/images/ai-tools-daily-update-07-30.svg" alt="AI Tools Daily Update November 12 2026 banner">

Enterprise agent infrastructure is finally hardening. Databricks shipped Genie 2.0. Mirantis and Komodor launched governed platforms for production agents. NVIDIA's Agent Substrate hit GA on GKE. OpenAI's DevDay follow-up dropped seven releases in a single day. Google's Gemini 4 Carbon pricing went live. And AWS published an emulator written entirely by autonomous agents.

---

## Enterprise Agent Infrastructure Hardens

### Databricks Genie 2.0 (Nov 11)

**Category:** Long-running agent | **Type:** Commercial SaaS (Databricks)

Databricks' second-gen Genie is an always-on autonomous AI coworker for complex enterprise work. You give it a goal and it proactively handles long-running tasks — tracking progress, following up on missing inputs, acting as new information arrives. The stack includes Genie Ontology (an agentic ontology built by agents, governed by people) and Genie Search (hybrid search across lakehouse and business systems). Priority inbox and email notifications surface human decisions. Runs within existing Databricks environments with Unity Catalog governance. Open-source foundation: Lakebase, Unity Gateway, Agent Bricks, Lakeflow.

### Mirantis Agent Platform (Nov 10)

**Category:** Long-running agent (platform) | **Type:** Commercial SaaS (Mirantis)

Self-hosted, governed environment for running AI agents in production on Kubernetes. Policy-based controls, configurable spend caps, full audit trails, network cutoff for rogue agent mitigation. Forward Deployed Engineering: senior Mirantis engineers work directly with client teams to design, integrate, and operationalize custom agents. GA at KubeCon North America. Integrates with k0rdent AI platform.

### Komodor Agentic Operations Platform (Nov 10)

**Category:** Long-running agent (operations) | **Type:** Commercial SaaS (Komodor)

Agentic Operations Platform for Production. Ready-to-run agentic workflows plus a foundation for building custom enterprise AI agents. SRE, platform engineering, DevOps workflow integration. Transforms operations from reactive to autonomous. IBM Ventures invested (announced Nov 10). Built on six years of mission-critical production problem-solving.

### NVIDIA Agent Substrate 1.0 GA on GKE (Nov 5)

**Category:** Long-running agent (infrastructure) | **Type:** Open source (CNCF Sandbox) / Commercial (NVIDIA/GCP)

Actor model with gVisor sandboxes per agent session, AgentGateway for identity/policy, sub-500ms session restoration. Accepted into CNCF Sandbox alongside gVisor and OpenRL. Powers kagent, Hermes Enterprise, SPIRITT Workspace. Complements Agent Compute Engine (Titanium microVMs with fast hibernation and parallel environment-forking).

---

## OpenAI DevDay Follow-Up: Seven Releases in One Day

All announced Nov 10 as part of the "28 days of shipping" cadence.

### GPT-6.1 Sol

**Category:** Frontier model | **Type:** Commercial API (OpenAI)

Major upgrade to GPT-6 Sol. Near-Astra intelligence for agentic coding, computer use, professional work — at 1/5 Astra's standard pricing. Available across all tiers (API, Plus, Pro, Business, Enterprise, Edu). Cached input $0.10/M tokens.

### Agents API with Computer Use (GA)

**Category:** Long-running agent | **Type:** Commercial API (OpenAI)

Agents now operate software through an OpenAI-hosted browser with website access approvals and sign-in handled by the application. Incorporates Codex's multi-agent capabilities, tool search, tool calling, context compaction. OpenAI manages the underlying execution infrastructure. Available via API and in Codex/ChatGPT Work on Pro 500 and Enterprise.

### Bedrock Managed Agents (Limited Preview)

**Category:** Long-running agent | **Type:** Commercial SaaS (AWS + OpenAI)

OpenAI agents running entirely inside AWS. Customer data never leaves Amazon's cloud. Native AWS resource integration. Built on OpenAI Agents API core with computer use support.

### Decisions API (Limited Preview)

**Category:** Decision-making API | **Type:** Commercial API (OpenAI)

Real-time decision-making with finite answer sets. Content classification, request routing, agent action selection. Uses Luna model. Text and image context support.

### Codex Security Cloud

**Category:** Security tooling | **Type:** Commercial SaaS (OpenAI)

On-demand and scheduled GitHub repo scanning. Continuous monitoring of new commits. Automatic investigation, deduplication, fix preparation. Daybreak Blue dedicated security model. Findings dashboard.

### Codex in the Cloud

**Category:** Coding agent | **Type:** Commercial SaaS (OpenAI)

Codex now runs locally, remotely from phone, or in the cloud from any device. Reusable cloud dev environments, team-shared configurations. New Codex CLI: voice launch, /agents view, worktree support, improved session recovery. Code Review in ChatGPT desktop app (PR/MR review with diff, questions).

### Dot Multi-Computer Support

**Category:** Long-running agent | **Type:** Commercial SaaS (OpenAI)

Dots (always-on ChatGPT assistants) now support multiple authorized computers per Dot. Per-task machine selection: Mac, Windows, or Dot's own cloud computer. Build/test on a dedicated machine while coding on your laptop.

---

## Infrastructure & Tools

### AWS Emulator (Nov 11)

**Category:** Infrastructure tool | **Type:** Open source (CC0)

Local AWS service emulator written 100% by autonomous AI agents. Thousands of agents write tests, find issues, fix code without human review. Tens of thousands of fidelity tests against real AWS. Continuously updated by agent swarms. Source and evaluation suite on GitHub under CC0.

### Dapr 1.19 (Nov 9)

**Category:** Long-running agent (infrastructure) | **Type:** Open source (CNCF/Diagrid)

Flat per-step network/memory cost for long-running workflows — workers keep history, receive only new events. Critical for agents running hours with dozens of parallel tasks. Merged Placement and Scheduler control-plane services. Diagrid Catalyst integration for Goose, LangChainGo, Mastra. Durable execution for mission-critical agent workloads.

---

## Model Updates

### Gemini 4 Carbon Pricing Live (Nov 11)

**Category:** Frontier model | **Type:** Commercial API (Google DeepMind)

Google's strongest model (cybersecurity specialization, long-horizon capabilities, 1M context). Introductory API pricing: $2/M input, $10/M output until Nov 30, then $4/$20. Initially rolling out to cyber defenders.

### Qwen4-Max Preview (Nov 11)

**Category:** Frontier model | **Type:** Commercial API (Qwen/Alibaba)

Qwen's latest flagship model preview. Tracked as the most recent AI model release.

### AlphaProof Code (Nov 11)

**Category:** Research/Verification agent | **Type:** Research project (Google DeepMind)

Multi-LLM agentic framework generated 6M+ lines of machine-checked Lean proofs, formally verified Signal libsignal security properties in ~4 weeks. Demonstrates long-horizon agentic reasoning for math/verification.

---

## KB Entities Created/Updated

Created entity cards in `~/Documents/knowledge_bases/ai_tools/entities/`:
- `databricks-genie` (new, Nov 11)
- `aws-emulator` (new, Nov 11)
- `gpt-6.1-sol` (new, Nov 10)
- `openai-agents-api-computer-use` (new, Nov 10)
- `bedrock-managed-agents` (new, Nov 10)
- `openai-decisions-api` (new, Nov 10)
- `codex-security-cloud` (new, Nov 10)
- `codex-cloud` (new, Nov 10)
- `openai-dot-multi-computer` (new, Nov 10)
- `dapr-1.19` (new, Nov 9)
- `mirantis-agent-platform` (new, Nov 10)
- `komodor-agentic-platform` (new, Nov 10)
- `qwen4-max-preview` (new, Nov 11)
- `alphaproof-code` (new, Nov 11)
- `nvidia-agent-substrate` (new, Nov 5)
- `gemini-4-carbon` (updated with entity.md, Nov 11)