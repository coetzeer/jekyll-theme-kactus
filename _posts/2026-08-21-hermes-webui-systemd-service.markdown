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

I’ve been running the [Hermes WebUI](https://github.com/NousResearch/hermes-webui) manually for a while. Usually, that means running `./start.sh`, which kicks off a detached process and leaves me to get on with my work. It’s fine for a quick session, but as soon as I log out or the machine restarts, the service dies.

I finally decided to turn it into a proper **systemd user service**. It turns out there's a much cleaner way to do this than just wrapping a background script, thanks to a specific flag that isn't immediately obvious in the shell defaults.

## The detached-script headache

`./start.sh` uses `bootstrap.py` to spawn `server.py` in the background. For systemd, this is messy. If you use `Type=forking`, you’re stuck managing PID files and hoping the process cleanup actually works.

The better approach: keep the process in the foreground. Let systemd track it natively.

## The discovery: --foreground auto-promotion

While poking around `bootstrap.py`, I realized it actually checks for supervisor environment variables like `INVOCATION_ID` (which systemd sets automatically). If it detects it's being run by a supervisor, it auto-promotes itself to `--foreground` mode.

In foreground mode, it skips the daemonization dance and the health probe. Systemd sees the real server PID from the start. This makes the service definition surprisingly simple.

## The unit file

I dropped this into `~/.config/systemd/user/hermes-webui.service`. Even though auto-detection would probably pick it up, I'm calling `bootstrap.py` directly with `--foreground` just to be explicit.

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
# Keep your VENV on the PATH so python finds its dependencies
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

On a headless server or working over SSH, you might hit the "Failed to connect to bus" error with `systemctl --user`. That just means the D-Bus session bus doesn't exist when you aren't actively logged in.

The fix is to enable user lingering. This tells systemd to keep your user manager and its bus alive even after you disconnect:

```bash
sudo loginctl enable-linger $USER
```

Now you can wire it up:

```bash
systemctl --user daemon-reload
systemctl --user enable --now hermes-webui.service
```

## Why this feels better

By using `Type=simple` and the foreground flag, I’m letting systemd do what it’s best at: managing lifecycles. If the server crashes, systemd restarts it in 5 seconds. If I need to troubleshoot, `journalctl --user -u hermes-webui -f` gives me the live stream immediately. No more hunting for orphaned PIDs or wondering if the background script actually stayed up.
