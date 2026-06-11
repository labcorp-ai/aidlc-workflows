# AI-DLC for Claude Code

This project uses the AI-DLC workflow methodology — a conversational, stage-driven approach to software development with human approval gates at every step.

## How to start

Describe what you want to build. Examples:
- "Build a task management API with user authentication"
- "Add a search feature to the existing product catalogue"
- "Fix the null pointer in the login handler"
- "Migrate our Express API to Fastify"

The orchestrator will welcome you, set up a workspace, compose an adaptive workflow with you, and drive each stage — using domain-expert sub-agents — until the work is done. You approve every plan and every artifact before the next stage begins.

## Orchestration

When you describe a development intent, load and follow `.claude/skills/aidlc-orchestration/SKILL.md`.

## Conventions and schemas

All workspace structure, state, audit, and workflow formats are defined in `.claude/conventions/`.

## Stages

Available stages and their dependency graph are in `.claude/stages/stage-graph.md`. Stage definitions and templates live in `.claude/stages/<stage-name>/`.

## Personas (sub-agents)

Domain-expert sub-agents are defined in `.claude/agents/`. The orchestrator invokes them; they never talk to the human directly.

## Skills

Domain skills used by personas are in `.claude/skills/`. Common skills (work method, prioritization) apply to all personas.
