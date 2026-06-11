# AI-DLC for Claude Code (v2)

A Claude Code-native port of the Kiro AI-DLC implementation. Same methodology, same stages, same agent roster — adapted to run inside Claude Code without any Kiro IDE dependency.

## Table of Contents

- [What this is](#what-this-is)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [How it works](#how-it-works)
  - [Starting a workflow](#starting-a-workflow)
  - [The three phases](#the-three-phases)
  - [Approval gates](#approval-gates)
  - [Autonomy modes](#autonomy-modes)
  - [Artifacts](#artifacts)
- [Stages](#stages)
- [Agents](#agents)
- [File structure](#file-structure)
- [Delta from Kiro](#delta-from-kiro)
  - [1. Agent format](#1-agent-format)
  - [2. Hook format](#2-hook-format)
  - [3. Internal file paths](#3-internal-file-paths)
  - [4. Bootstrap entrypoint](#4-bootstrap-entrypoint)

## What this is

AI-DLC is a conversational, stage-driven software development methodology. You describe what you want to build; the orchestrator composes an adaptive workflow with you, then drives each stage using domain-expert sub-agents. You approve every plan and every artifact before the next stage begins.

This implementation mirrors the Kiro version exactly in content and behaviour. The only differences are structural adaptations required to run in Claude Code — see [Delta from Kiro](#delta-from-kiro) below.

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) — native install recommended
- [Node.js](https://nodejs.org/) — required by the process checker tool (`node`)

## Installation

Copy the `.claude/` directory into your project root:

```bash
cp -r dist/claude/.claude/ /path/to/your-project/.claude/
```

That's it. No build step, no package install. All skills, agents, stages, and tools are plain Markdown, JSON, and a single Node.js script.

### Verify

Open your project in Claude Code and describe a development intent:

```
Build a task management API with user authentication
```

The orchestrator should respond with the AI-DLC welcome banner and begin the kickoff sequence.

## How it works

### Starting a workflow

Describe what you want to build in natural language. The orchestrator detects development intent and loads automatically via `CLAUDE.md`.

```
Add a search feature to the existing product catalogue
Fix the null pointer in the login handler
Migrate our Express API to Fastify
Build a library management app with admin and member roles
```

### The three phases

1. **Kickoff** — workspace is set up under `org-ai-kb/aidlc-docs/intent-<nnn>-<slug>/`
2. **Workflow composition** — the orchestrator reads the stage graph, paraphrases your intent, asks the minimum questions, and proposes a stage table for your approval
3. **Stage execution** — each stage runs through a plan → clarify → produce → review → approve cycle

### Approval gates

Every stage blocks on human approval before proceeding (default `supervised` mode). Stages can be set to `full` autonomy in `workflow.json` to auto-approve gates.

### Autonomy modes

| Mode | Behaviour |
|---|---|
| `supervised` | Human gates block. You approve plans, answers, and artifacts. |
| `full` | Human gates auto-approve. Audit entries note "auto-approved (full autonomy)." |

### Artifacts

All outputs are written to disk under the intent directory — never only in chat. The directory structure after a full workflow:

```
org-ai-kb/aidlc-docs/intent-001-<slug>/
├── intent.md
├── workflow.json
├── state/state.json
├── audit/audit.json
└── stages/
    ├── inception/
    │   ├── requirements-analysis/
    │   ├── story-generation/
    │   ├── wireframe-design/
    │   ├── domain-design/
    │   ├── units-generation/
    │   └── contract-design/
    └── construction/
        └── <unit-name>/
            ├── functional-design/
            ├── nfr-design/
            ├── infrastructure-design/
            └── code-generation/
```

## Stages

11 domain stages, composable per intent:

| Stage | Owner | Purpose |
|---|---|---|
| `reverse-engineering` | Systems Architect | Analyse existing codebase; produce architecture artifacts |
| `requirements-analysis` | Product Manager | Elicit and structure functional + non-functional requirements |
| `story-generation` | Product Manager | Decompose requirements into user and system stories |
| `wireframe-design` | UX Designer | Design UI screens as browser-openable HTML wireframes |
| `domain-design` | App Architect | Identify logical components and their boundaries |
| `units-generation` | App Architect | Group components into deployable units |
| `contract-design` | App Architect | Define inter-unit contracts for parallel development |
| `functional-design` | Systems Architect | Detail business logic, entities, rules, and API spec per unit |
| `nfr-design` | Systems Architect | Define quality targets, tech stack, architectural patterns |
| `infrastructure-design` | Systems Architect | Map components to infrastructure services and deployment |
| `code-generation` | SW Dev Engineer | Generate production code with write-test-verify cycles |

## Agents

8 domain-expert sub-agents. The orchestrator invokes them; they never speak to the human directly.

| Agent | Role |
|---|---|
| `aidlc-product-manager-agent` | Product Owner — requirements and stories |
| `aidlc-product-lead-agent` | Product Lead — reviews product artifacts |
| `aidlc-ux-designer-agent` | UX Designer — wireframes and screen flows |
| `aidlc-app-architect-agent` | App Architect — components, units, contracts |
| `aidlc-systems-architect-agent` | Systems Architect — NFR, infrastructure, reverse-engineering |
| `aidlc-architecture-reviewer-agent` | Architecture Reviewer — reviews technical artifacts |
| `aidlc-code-reviewer-agent` | Code Reviewer — reviews generated code |
| `aidlc-sw-dev-engineer-agent` | SWE — implements production code |

## File structure

```
dist/claude/.claude/
├── CLAUDE.md                        # Bootstrap — loads orchestration on dev intent
├── settings.json                    # PostToolUse hook for process checker
├── agents/                          # 8 agent definitions (Markdown frontmatter)
├── conventions/                     # State, workflow, audit schemas + folder/question formats
├── hooks/
│   └── aidlc-process-checker.sh    # Shell wrapper for process-checker.js
├── skills/
│   ├── aidlc-orchestration/         # Main orchestrator
│   ├── aidlc-kickoff/               # Workspace setup
│   ├── aidlc-workflow-composition/  # Adaptive workflow composer
│   ├── aidlc-stage-execution/       # Stage cycle driver
│   ├── common/                      # aidlc-work-method, aidlc-prioritization
│   └── aidlc-*-skill/              # 10 domain skills (requirements, API design, etc.)
├── stages/
│   ├── stage-graph.md               # Stage dependency graph + composition rules
│   └── <stage-name>/
│       ├── definition.md            # Stage description, inputs, outputs
│       └── templates/               # Output artifact templates
└── tools/
    └── process-checker.js           # Verifies artifact outputs and contributions
```

---

## Delta from Kiro

This implementation is a direct port of the Kiro version. The methodology, stages, agents, skills, and conventions are identical. Only the following were changed to fit the Claude Code runtime:

### 1. Agent format

| | Kiro | Claude Code v2 |
|---|---|---|
| **Format** | JSON with embedded YAML string in `prompt` field | Markdown with YAML frontmatter |
| **Skill references** | `"resources": ["skill://.kiro/skills/..."]` | Prose `Read` instructions in agent body |
| **File extension** | `.json` | `.md` |

Kiro example:
```json
{
  "name": "aidlc-product-manager-agent",
  "prompt": "\"\"\\n\\nname: ...\\nbehaviour: |\\n  ...",
  "resources": ["skill://.kiro/skills/aidlc-requirements-analysis-skill/SKILL.md"]
}
```

Claude Code v2 equivalent:
```markdown
---
name: aidlc-product-manager-agent
disallowedTools: Task
---
You are a Product Owner...

Read `.claude/skills/aidlc-requirements-analysis-skill/SKILL.md`
```

### 2. Hook format

| | Kiro | Claude Code v2 |
|---|---|---|
| **Format** | `.kiro.hook` JSON file with `when`/`then` structure | `settings.json` `PostToolUse` entry |
| **Tool match** | `"toolTypes": ["invoke_sub_agent"]` | `"matcher": "Task"` |
| **Action type** | `"type": "askAgent"` | `"type": "prompt"` |

Kiro (`.kiro/hooks/process-checker.kiro.hook`):
```json
{
  "when": { "type": "postToolUse", "toolTypes": ["invoke_sub_agent"] },
  "then": { "type": "askAgent", "prompt": "Run the process checker..." }
}
```

Claude Code v2 (`settings.json`):
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Task",
      "hooks": [{ "type": "prompt", "prompt": "Run the process checker..." }]
    }]
  }
}
```

### 3. Internal file paths

All `.kiro/` path prefixes in the orchestration skills were updated to `.claude/`:

| Kiro path | Claude Code v2 path |
|---|---|
| `stages/stage-graph.md` | `.claude/stages/stage-graph.md` |
| `conventions/` | `.claude/conventions/` |
| `skills/common/aidlc-work-method/SKILL.md` | `.claude/skills/common/aidlc-work-method/SKILL.md` |
| `tools/process-checker.js` | `.claude/tools/process-checker.js` |

Affected files: `aidlc-orchestration/SKILL.md`, `aidlc-kickoff/SKILL.md`, `aidlc-workflow-composition/SKILL.md`, `aidlc-stage-execution/SKILL.md`.

All 12 domain skills, both common skills, all stage definitions and templates, conventions, and `process-checker.js` were copied verbatim — no changes.

### 4. Bootstrap entrypoint

Kiro activates skills through its own IDE registry. Claude Code requires a `CLAUDE.md` at `.claude/CLAUDE.md` that instructs the model to load `aidlc-orchestration/SKILL.md` when it detects a development intent. This file has no Kiro equivalent.
