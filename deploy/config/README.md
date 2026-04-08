# Config fragments

These files are designed to be used either as references or via OpenClaw's `$include` support.

Suggested order:

1. `auth.example.json5`
2. `models.example.json5`
3. `channels.bindings.example.json5`
4. `cron.runtime.json5`
5. `openclaw.with-includes.example.json5`

The root `openclaw.json` in this package already includes a safe starter version of:
- `identity`
- `gateway.reload`
- `cron` retention
- disabled Telegram accounts
- routing `bindings`
- placeholder `auth` and `model` catalog
