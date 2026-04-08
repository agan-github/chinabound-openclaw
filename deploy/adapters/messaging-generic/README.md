# Generic messaging adapter contract

This adapter is the handoff point between `messaging` and a real delivery platform.
It should support:
- dry-run preview
- per-channel rendering
- template parameter validation
- message id capture for audit
