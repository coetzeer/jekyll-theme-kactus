---
title: "Running the Hermes Dashboard as a Systemd User Service"
date: 2026-08-16 12:55:00 +0200
description: "How to create, enable, and run a systemd user unit for the Hermes Agent web dashboard, including the fix for 'Failed to connect to bus: No medium found' via user lingering."
categories: [self-hosted, devops, hermes-agent]
tags: [systemd, jekyll, dashboard, linux, devops]
layout: post
---

This is a story about a systemd unit file, a D-Bus session that *almost* wasn't there, and a dashboard that ended up running on boot. Below is the complete walkthrough — the unit file I wrote, why it's structured the way it is, the one-liner that fixed the dreaded `Failed to connect to bus: No medium found` error, and the exact commands to manage the service day-to-day.

## Why a systemd unit for the dashboard?

The [Hermes Agent](https://hermes-agent.nousresearch.com/docs) web dashboard is the GUI for managing config, API keys, and sessions. Launching it by hand from a terminal works, but it:

- dies when you close your shell,
- doesn't start on boot,
- gives you no clean `stop` that respects the process lifecycle.

A **systemd user service** solves all three — it starts on login (or boot with lingering), restarts on failure, and gives you `systemctl --user start|stop|status` semantics.

## The unit file

I placed it at the user-unit path that mirrors the existing `hermes-gateway.service` already living in this environment:

`~/.config/systemd/user/hermes-dashboard.service`

```ini
[Unit]
Description=Hermes Agent Web Dashboard - Config, API keys, sessions
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=$HOMEDIR/.hermes/hermes-agent/venv/bin/hermes dashboard --port 9119 --host 127.0.0.1 --no-open
ExecStop=$HOMEDIR/.hermes/hermes-agent/venv/bin/hermes dashboard --stop
WorkingDirectory=$HOMEDIR/.hermes
Environment="PATH=$HOMEDIR/.hermes/hermes-agent/venv/bin:$HOMEDIR/.hermes/hermes-agent/node_modules/.bin:$HOMEDIR/.hermes/node/bin:$HOMEDIR/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
Environment="VIRTUAL_ENV=$HOMEDIR/.hermes/hermes-agent/venv"
Environment="HERMES_HOME=$HOMEDIR/.hermes"
Restart=on-failure
RestartSec=5
KillMode=mixed
KillSignal=SIGTERM
TimeoutStopSec=60
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=default.target
```

### Design notes

- **Absolute paths everywhere.** `ExecStart`/`ExecStop` and `WorkingDirectory` use absolute paths because, in a systemd unit, the working directory and `$PATH` are *not* what you'd get in an interactive shell. The venv `hermes` binary resolves to `/home/raymondcoettsee/.hermes/hermes-agent/venv/bin/hermes`.
- **`--no-open`** — headless-safe. The dashboard would otherwise try to spawn a browser; in a server or SSH context that's noise (or a failure).
- **`--host 127.0.0.1`** — the dashboard binds loopback only. The June 2026 hardening means a public bind *always* requires an auth provider; loopback + an SSH tunnel is the recommended pattern for remote access.
- **`ExecStop` runs the project's own stop command** (`hermes dashboard --stop`) rather than relying on a bare `KillSignal`. This lets the dashboard tear down its server cleanly. `KillMode=mixed` is the fallback: systemd sends `SIGTERM` to the main process after `TimeoutStopSec`, and `SIGKILL` is reserved for forked children only.
- **Environment mirrors `hermes-gateway.service`** — same `PATH`, `VIRTUAL_ENV`, and `HERMES_HOME` — so the dashboard binary resolves and inherits the same profile config the gateway uses.
- **`Restart=on-failure`** with a 5-second backoff. I deliberately did *not* use `Restart=always` here: an intentional `ExecStop` (exit via `--stop`) should not trigger a restart loop.
- **`WantedBy=default.target`** — the user-session equivalent of `multi-user.target`; `systemctl --user enable` symlinks this into `default.target.wants/`.

The `--port 9119` is the default but stated explicitly so the unit is self-documenting and easy to change.

## The "Failed to connect to bus" problem (and the fix)

If you try the obvious thing right away —

```bash
systemctl --user daemon-reload
```

— you may hit:

```
Failed to connect to bus: No medium found
```

**Why this happens:** `systemctl --user` talks to systemd over a per-user **D-Bus session bus**. That bus only exists when the user is *logged in* (graphically or over SSH). In a headless box or an SSH session without a proper login shell, there's no bus socket — and `systemctl --user` has nothing to connect to.

The fix is **user lingering**, which tells `systemd --user` / `logind` to spin up and keep alive a persistent user manager instance (`user@UID.service`) plus its D-Bus session, even when no one is logged in:

```bash
sudo loginctl enable-linger raymondcoetzee
```

After that runs, `/run/user/1000/` is created, including the `bus` socket at `/run/user/1000/bus`. You can verify with:

```bash
loginctl show-user raymondcoetzee          # should show Linger=yes
ls -la /run/user/1000                       # should contain bus, systemd/
```

> On Debian/Ubuntu, `loginctl` is provided by `libpam-systemd`, which is installed but not always configured for non-login contexts. Lingering is the canonical, package-supported way to make `systemctl --user` work for unattended users.

### Connecting when the login shell doesn't set `XDG_RUNTIME_DIR`

Even after enabling linger, a `sudo -u raymondcoettsee systemctl --user …` invocation can still fail — `sudo -u` doesn't propagate `XDG_RUNTIME_DIR` or `DBUS_SESSION_BUS_ADDRESS`, so systemctl doesn't know where the bus socket is. If you ever run into that, point the environment at the user's runtime dir explicitly:

```bash
export XDG_RUNTIME_DIR=/run/user/1000
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
systemctl --user daemon-reload
```

In a real login session these are set automatically; the manual export is only needed for scripts or non-login contexts.

## Wiring it up

With linger enabled and the unit file in place:

```bash
systemctl --user daemon-reload
systemctl --user enable --now hermes-dashboard.service
```

`enable` creates the `default.target.wants/` symlink (starts on boot/login); `--now` also starts it immediately.

## Verifying it works

```bash
systemctl --user status hermes-dashboard.service
```

```
● hermes-dashboard.service - Hermes Agent Web Dashboard - Config, API keys, sessions
     Loaded: loaded (/home/.../hermes-dashboard.service; enabled; preset: enabled)
     Active: active (running) since Sun 2026-08-16 12:48:16 CEST; 19ms ago
   Main PID: 1869952 (hermes)
      Tasks: 1 (limit: 14306)
   Memory: 3.0M (peak: 3.0M)
      CPU: 13ms
```

And a quick HTTP probe confirms the server is actually serving:

```bash
curl -sS -o /dev/null -w 'HTTP %{http_code} in %{time_total}s\n' http://127.0.0.1:9119/
```

```
HTTP 200 in 0.079096s
```

Logs live in the journal, as configured by `StandardOutput=journal` / `StandardError=journal`:

```bash
journalctl --user -u hermes-dashboard.service -f
```

## Day-to-day management

| Goal | Command |
|------|---------|
| Start | `systemctl --user start hermes-dashboard.service` |
| Stop | `systemctl --user stop hermes-dashboard.service` |
| Restart | `systemctl --user restart hermes-dashboard.service` |
| Status | `systemctl --user status hermes-dashboard.service` |
| Follow logs | `journalctl --user -u hermes-dashboard.service -f` |
| Disable + stop | `systemctl --user disable --now hermes-dashboard.service` |

## Takeaway

The unit file itself is short; most of the friction was the environment around it. Lying in wait behind "Failed to connect to bus" is a missing D-Bus session — solved, once and for all, by a single `loginctl enable-linger` call. After that, the Hermes dashboard behaves like any well-behaved daemon: starts on boot, restarts on failure, and logs to the journal.
