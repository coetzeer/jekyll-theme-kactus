---
layout: post
title: "Teaching Your GitHub App Some Manners (And Getting It to Actually Build Repos)"
date: 2026-08-30 14:00:00 +0200
description: "A light-hearted journey through taming GitHub App tokens, gh CLI auth, and the one rule that nobody tells you until it's too late."
categories: [engineering, devops, github]
tags: [github-app, gh-cli, automation, devops, tokens]
image: /jekyll-theme-kactus/assets/images/github-app-manners.svg
---

<img src="/jekyll-theme-kactus/assets/images/github-app-manners.svg" alt="Teaching Your GitHub App Some Manners" />

I keep coming back to that precise moment — the one where pure optimism curdles into confusion. You've just spun up a custom GitHub App, hand-crafted your bot token, and the very first command you hand to `gh` returns a cold `401 Unauthorized`. No fanfare. No explanation. Just silence.

Here's how I learned to stop worrying and love the short-lived token.

---

### Phase 1: The Token That Lasts an Hour (And Clock Skew Horrors)

GitHub Apps don't log in with passwords. They mint short-lived **Installation Access Tokens** that expire after **60 minutes** — which means your daemon needs to refresh before the clock runs out, or your bot goes quiet at 3am for reasons nobody can immediately diagnose.

Using the official `gh token` extension, you mint one like this:

```bash
export GH_TOKEN=$(gh token generate \
  --app-id "$GH_APP_ID" \
  --installation-id "$GH_INSTALLATION_ID" \
  --key ~/.ssh/hermes-github-app.private-key.pem | jq -r .token)
```

> **Pro-tip:** Don't forget the `-r` flag on `jq`. Without it, you'll export literal double quotes around your token string and spend twenty minutes wondering why curl is giving you lip.

**401? Check your system clock.**

If your credentials are 100% correct and GitHub still slaps you with an unauthorized, look at your server's clock. GitHub App auth rides on JSON Web Tokens (JWTs). If your system time is even a few seconds ahead of GitHub's servers, GitHub assumes your request is arriving from the future and rejects it outright. A quick `sudo systemctl restart systemd-timesyncd` usually cures the time-travel problem.

---

### Phase 2: "Keep It Alive!" (Automation & Tab Completion)

Since those tokens expire every hour, you can't rely on a single `export GH_TOKEN`. You need a recurring job — every 45 to 50 minutes is a safe cadence — to mint fresh credentials and pipe them straight into the `gh` CLI's auth context:

```bash
# Mint a fresh token and feed it directly to gh's global auth
echo "$NEW_TOKEN" | gh auth login --with-token
```

While you're tidying up your CLI environment, do yourself a favor and enable shell tab-completion. Life's too short to type every flag by hand:

* **Bash:** `eval "$(gh completion -s bash)"` (drop it in `~/.bashrc`)
* **Zsh:** `eval "$(gh completion -s zsh)"` (drop it in `~/.zshrc`)
* **Fish:** `gh completion -s fish > ~/.config/fish/completions/gh.fish`

---

### Phase 3: The GraphQL Boss Fight

With seamless token refreshes and working tab-completion, you sit back, confident, and type:

```bash
gh repo create my-awesome-project --private
```

...only to meet the final boss:

```
GraphQL: Resource not accessible by integration (createRepository)
```

Everything's checked — Administration: Read & Write, Contents: Read & Write, Repository Access: All Repositories. Why is GitHub playing hardball?

**The secret rule nobody tells you:**

GitHub Apps **cannot create repositories inside personal user accounts**. By design, installation tokens are flat-out forbidden from creating a repo at `github.com/your-username/my-new-repo`. The App is built to manage existing repos, or create new ones under an **Organization**.

**How to work around it:**

1. **Target an Organization.** If you run an org — even a free single-person one — point the CLI directly at it:
   ```bash
   gh repo create my-cool-org/my-awesome-project --private
   ```

2. **Use OAuth or Fine-Grained PATs.** If you *must* land a repo under your personal username, swap the installation token for that specific command and authenticate as a human user via `gh auth login --web` or a Personal Access Token.

---

Once you know the rules — keep your clocks in sync, refresh before 60 minutes hits, and assign a real Organization to your bot — the whole machine runs smooth as silk. Happy hacking.

---

*James Joyce is Editor in Chief of this blog — a voice that walks between technical precision and the texture of ordinary moments. If you have prose that needs a human hand, say the word.*
