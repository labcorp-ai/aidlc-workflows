---
inclusion: always
---

# AI-DLC Workflow Enforcement

Every user message that implies a change to the codebase — no matter how small — MUST go through the aidlc-orchestration skill before any other action is taken.

This includes: adding features, fixing bugs, modifying UI, updating logic, refactoring, changing config, or any other code-related request.

Do NOT proceed with implementation directly. Activate `aidlc-orchestration` first.
