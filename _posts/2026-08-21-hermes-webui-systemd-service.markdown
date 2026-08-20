---
title: "Running Hermes WebUI as a Proper Systemd Service"
date: 2026-08-21 00:30:00 +0200
description: "Setting up a systemd user unit for the Hermes WebUI, and why the hidden --foreground flag makes it work better than manual background scripts."
categories: [self-hosted, devops, ai]
tags: [hermes-webui, systemd, linux, devops]
layout: post
image: /jekyll-theme-kactus/assets/images/2026-08-21-hermes-webui-systemd-service.svg
---

![Hermes WebUI systemd service architecture](/jekyll-theme-kactus/assets/images/2026-08-21-hermes-webui-systemd-service.svg)

I've been running the [Hermes WebUI](https://github.com/NousResearch/hermes-webui) manually for a while now. It usually starts with a quick `./start.sh`, which kicks off a detached background process and leaves you to get on with your work. It's fine for a quick session, but as soon as you logout or the machine restarts, you're back to square one.

I decided to move it over to a proper **systemd user service**. It turns out there's a much cleaner way to do this than just wrapping the background script, thanks to a specific flag that isn't immediately obvious if you just stick to the shell defaults.

## The problem with detached scripts

When you run `./start.sh`, it uses `bootstrap.py` to spawn `server.py` in the background. For systemd, this is a bit of a headache. If you use `Type=forking`, you have to deal with PID files and hope the process cleanup works correctly when you want to stop the service.

The better way is to keep the process in the foreground and let systemd track it natively.

## The discovery: --foreground auto-promotion

While looking through the `bootstrap.py` source, I found that it actually checks for supervisor environment variables like `INVOCATION_ID` (which systemd sets automatically). If it detects it's being run by a supervisor, it auto-promotes itself to `--foreground` mode.

In foreground mode, it skips the daemonization dance and the post-launch health probe, letting systemd see the real server PID from the start. This makes the service definition incredibly simple.

## The unit file

I dropped this into `~/.config/systemd/user/hermes-webui.service`. Note the `ExecStart` line — I'm calling `bootstrap.py` directly with the `--foreground` flag to be explicit, though the auto-detection would probably handle it anyway.

```ini
[Unit]
Description=Hermes WebUI - local agent web interface
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=$HOMEDIR/Documents/hermes-webui/bootstrap.py --no-browser --foreground --host 127.0.0.1 8787
WorkingDirectory=$HOMEDIR/Documents/hermes-webui
Environment="HOME=$HOMEDIR"
# Make sure your VENV is on the PATH so python finds its dependencies
Environment="PATH=$HOMEDIR/.hermes/hermes-agent/venv/bin:/usr/local/bin:/usr/bin:/bin"
Environment="HERMES_WEBUI_HOST=127.0.0.1"
Environment="HERMES_WEBUI_PORT=8787"
Environment="HERMES_WEBUI_STATE_DIR=$HOMEDIR/.hermes/webui"
Environment="HERMES_WEBUI_AGENT_DIR=$HOMEDIR/.hermes/hermes-agent"
Restart=on-failure
RestartSec=5
KillMode=control-group
KillSignal=SIGTERM
TimeoutStopSec=30
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=default.target
```

## Setup and Linger

If you're on a headless server or working over SSH, you'll likely hit the "Failed to connect to bus" error when you try to run `systemctl --user`. This happens because the D-Bus session bus only exists while you're actively logged in.

The fix is to enable user lingering, which tells systemd to keep your user manager and its bus alive even after you disconnect:

```bash
sudo loginctl enable-linger $USER
```

Once that's done, you can wire up the service:

```bash
systemctl --user daemon-reload
systemctl --user enable --now hermes-webui.service
```

## Why this is better

By using `Type=simple` and the foreground flag, I'm letting systemd do what it's best at: managing lifecycles. If the server crashes, systemd restarts it in 5 seconds. If I want to see what's happening, `journalctl --user -u hermes-webui -f` gives me the live stream. No more hunting for orphaned PIDs or wondering if the background script actually stayed up.
