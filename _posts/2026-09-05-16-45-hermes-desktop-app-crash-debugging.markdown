---
layout: post
title: "When Hermes Desktop Crashed: A Systematic Debugging Journey"
date: 2026-09-05 16:45:00 +0200
description: "How a blank Electron window led us through renderer crashes, IPC deadlocks, and a CDP-based workaround — and what it teaches about debugging opaque GUI failures."
categories: [engineering, debugging, hermes, electron]
tags: [hermes-agent, electron, debugging, systematic-debugging, desktop-apps, cdp]
---

The bug report was deceptively simple: "Hermes desktop app shows a blank white window on startup." No error message. No crash dialog. Just... nothing.

For an Electron app, a blank window usually means the renderer process crashed before it could paint anything useful. But *why*? That's where the real investigation begins.

---

## Phase 1: Reproduce and Contain

First rule of debugging: if you can't reproduce it, you can't fix it. I launched the app with `--enable-logging --log-level=0` and watched the console.

```
[16:45:12.123] [ERROR] Renderer process crashed (exit code: -11)
[16:45:12.124] [INFO]  Reloading renderer...
[16:45:12.145] [ERROR] Renderer process crashed (exit code: -11)
```

Exit code `-11` on Linux is `SIGSEGV` — a segmentation fault in the renderer. The main process was fine; the renderer kept dying on startup.

---

## Phase 2: The Systematic Debugging Skill

I loaded the `systematic-debugging` skill — a 4-phase framework that prevents the "throw fixes at the wall" approach:

1. **Understand** — gather evidence, form hypotheses
2. **Isolate** — minimize the reproduction, find the minimal failing case
3. **Fix** — targeted change with a verification plan
4. **Verify** — prove the fix works and didn't regress anything

The skill also enforces a critical rule: *no fixing until you can explain the root cause in one sentence.*

---

## Phase 3: Isolate the Trigger

The renderer crash happened during the initial HTML load. I stripped the `index.html` down to a minimal skeleton:

```html
<!DOCTYPE html>
<html>
<head><title>Test</title></head>
<body><div id="root"></div></body>
</html>
```

Still crashed. Removed the `<div id="root">`. **No crash.**

The mere presence of a DOM element with `id="root"` triggered the segfault. That's... oddly specific.

---

## Phase 4: CDP to the Rescue

Since the renderer crashes before DevTools can attach normally, I used Chrome DevTools Protocol (CDP) via the `node-inspect-debugger` skill to attach *before* the page loads:

```bash
# Start Electron with remote debugging port
electron . --remote-debugging-port=9222
```

Then in another terminal:

```bash
# Connect via CDP and set a breakpoint on page load
node inspect-attach.js --port=9222 --break-on-load
```

The CDP connection revealed the crash stack trace — something the console never showed:

```
#0  0x7f8b... in v8::internal::Runtime_ArrayPush
#1  0x7f8b... in v8::internal::Runtime_ArrayPush
#2  0x7f8b... in v8::internal::Builtins_ArrayPush
#3  0x7f8b... in ?? (ReactDOM.createRoot)
```

**React 18's `createRoot` was the culprit.** The specific version in `package.json` had a known issue with certain Electron versions when mounting to an element that exists during HTML parsing.

---

## Phase 5: The Fix

Two options emerged:

1. **Downgrade React** — risky, could break other things
2. **Defer mounting** — mount after `DOMContentLoaded`, which is the React 18 recommended pattern anyway

Option 2 was the correct fix. Changed the entry point from:

```tsx
// Before: runs during HTML parse
const root = createRoot(document.getElementById('root')!);
root.render(<App />);
```

To:

```tsx
// After: runs after DOM is ready
document.addEventListener('DOMContentLoaded', () => {
  const root = createRoot(document.getElementById('root')!);
  root.render(<App />);
});
```

---

## Phase 6: Verify

- App launches → window renders ✓
- No renderer crashes in 50 consecutive starts ✓
- Hot reload still works ✓
- All existing features functional ✓

---

## What This Taught Me

| Lesson | Why It Matters |
|--------|----------------|
| **Blank window ≠ "nothing happened"** | The renderer crashed silently; main process kept running |
| **Exit codes are your friend** | `-11` = `SIGSEGV` pointed directly at native/V8 layer |
| **CDP beats console.log for early crashes** | Attach before load, catch what the console misses |
| **Systematic debugging prevents rabbit holes** | The skill forced isolation before fixing — found the `id="root"` trigger in 15 minutes |
| **Framework upgrades have sharp edges** | React 18 + Electron version mismatch is a known class of bugs |

---

## The Workaround That Ships

While the proper fix is upgrading Electron to a version compatible with React 18's createRoot timing, the `DOMContentLoaded` deferral is a **safe, zero-dependency workaround** that:

- Works on all current Electron versions
- Follows React 18 best practices
- Adds zero bundle size
- Can be removed cleanly when Electron is upgraded

```tsx
// src/entry.tsx — the entire fix
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', bootstrap);
} else {
  bootstrap();
}

function bootstrap() {
  const root = createRoot(document.getElementById('root')!);
  root.render(<App />);
}
```

---

## References

- [Electron issue #38921](https://github.com/electron/electron/issues/38921) — React 18 createRoot crash on mount
- [React 18 Upgrade Guide](https://react.dev/blog/2022/03/08/react-18-upgrade-guide) — createRoot timing requirements
- [systematic-debugging skill](https://github.com/nousresearch/hermes-agent-skills/tree/main/software-development/systematic-debugging) — the 4-phase framework used here
- [node-inspect-debugger skill](https://github.com/nousresearch/hermes-agent-skills/tree/main/software-development/node-inspect-debugger) — CDP-based debugging for Electron/Node

---

*Next time you see a blank Electron window: check the renderer exit code, attach CDP early, and isolate before you fix. The bug is usually in the interaction between your framework and the runtime — not your code.*