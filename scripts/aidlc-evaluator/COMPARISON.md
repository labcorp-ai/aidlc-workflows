# AIDLC Evaluator — Kiro vs Raw Rules Comparison

> **Date:** 2026-05-21
> **Scenario:** sci-calc-v2 (Scientific Calculator REST API, greenfield)
> **Model:** `global.anthropic.claude-opus-4-6-v1` (both runs)
> **Branch:** `v2-evaluator`

Two execution modes evaluated against the same benchmark:

| Mode | Description |
|------|-------------|
| **Kiro** | Kiro IDE with v2 `.kiro/` distribution. Orchestrator, builder, and validator are native Kiro sub-agents. `process_checker.js` enforced via `process-check-hook.json` after every sub-agent call. |
| **Raw Rules** | Strands multi-agent swarm (orchestrator → builder → validator → simulator). Rules loaded from `src/` at runtime. `process_checker.js` enforced via `ProcessCheckerHook` after each builder/validator turn. |

---

## Verdict

| Dimension | Kiro | Raw Rules | Winner |
|-----------|-----:|----------:|--------|
| **Qualitative score** | 🟡 0.74 | 🟢 **0.86** | Raw Rules |
| **Unit tests** | ✅ 124/124 | ✅ **348**/348 | Raw Rules |
| **Contract tests** | ✅ 88/88 | ✅ 88/88 | Tie |
| **Lint warnings** | ✅ 0 | ✅ 0 | Tie |
| **Security findings** | ✅ 0 | ✅ 0 | Tie |
| **Wall clock** | 🏆 **27.6 min** | 59.6 min | Kiro |
| **Unique tokens** | N/A | 10.5M | N/A |
| **Repeated context** | N/A | 80.9M | N/A |

---

## Speed & Efficiency

| Metric | Kiro | Raw Rules |
|--------|-----:|----------:|
| Wall clock | **27.6 min** | 59.6 min |
| Kiro turns / Swarm handoffs | 20 turns | 45 handoffs |
| Unique tokens | N/A (not metered) | 10.5M |
| Repeated context tokens | N/A | 80.9M |
| Source files generated | 538 | ~1,000+ |
| Lines of code | 207,983 | ~350,000 |

Kiro completes in roughly half the time. The Strands swarm generates more code (more test files, more modular structure) at the cost of longer execution and significantly more token usage due to context re-sending across 45 handoffs.

---

## Code Quality

Both runs produced clean code with zero lint errors and zero security findings.

| Metric | Kiro | Raw Rules |
|--------|-----:|----------:|
| Unit tests | 124/124 (100%) | **348/348** (100%) |
| Contract tests | 88/88 (100%) | 88/88 (100%) |
| Lint errors | 0 | 0 |
| Lint warnings | 0 | 0 |
| Security high | 0 | 0 |

Raw Rules generates nearly 3× more unit tests, reflecting more granular test coverage. Both pass all 88 contract endpoint validations.

---

## Qualitative Score (Document Quality vs Golden)

Scores reflect semantic similarity to the golden master documents, assessed by LLM across three dimensions: intent alignment, design quality, and completeness.

### Overall

| Phase | Kiro | Raw Rules |
|-------|-----:|----------:|
| **Overall** | **0.7429** | **0.8622** |
| Bootstrap | 0.8725 | **0.9432** |
| Inception | 0.6447 | **0.8525** |
| Construction | 0.5793 | **0.8480** |
| Other (intent, workflow) | **0.8750** | 0.8050 |

### Per-Document Breakdown

#### Bootstrap Phase

| Document | Kiro | Raw Rules |
|----------|-----:|----------:|
| `bootstrap-context.md` | 1.00 | 1.00 |
| `intent-bootstrap-questions.md` | 0.88 | 0.89 |
| `workflow-composition-questions.md` | 0.84 | **0.94** |
| `workflow-composition/validation-report.md` | — | 0.93 |
| `workflow-rationale.md` | 0.77 | **0.96** |

Raw Rules produces a richer workflow-composition with a validation report and more detailed rationale.

#### Inception Phase

| Document | Kiro | Raw Rules |
|----------|-----:|----------:|
| `requirements-analysis-plan.md` | 0.83 | **0.88** |
| `requirements-analysis-questions.md` | 0.18 | **0.77** |
| `requirements.md` | 0.92 | **0.94** |
| `validation-report.md` | — | 0.83 |

The biggest gap is `requirements-analysis-questions.md` (0.18 vs 0.77). Kiro's builder judged "no clarification needed" given the detailed vision and produced a near-empty questions file. Raw Rules generated 7 substantive questions with trade-off analysis. See [ISSUES.md ISSUE-007](../ISSUES.md).

#### Construction Phase

| Document | Kiro | Raw Rules |
|----------|-----:|----------:|
| `CODE_SUMMARY.md` | 0.80 | — |
| `code-generation-plan.md` | 0.78 | **0.85** |
| `code-generation-questions.md` | 0.16 | — |

Raw Rules produces a more complete code generation plan. Kiro again shows the empty-questions pattern (0.16).

#### Other (intent.md, workflow.md)

| Document | Kiro | Raw Rules |
|----------|-----:|----------:|
| `intent.md` | 0.91 | 0.91 |
| `workflow.md` | **0.84** | 0.70 |

Kiro's workflow.md scores slightly higher — it used cleaner relative paths vs Raw Rules' `org-ai-kb/` prefixed paths.

---

## Key Observations

**1. Raw Rules produces higher quality documentation**
The Strands multi-agent swarm generates richer artifacts — more questions, validation reports, and more detailed plans — across every phase. The separation of builder, validator, and orchestrator roles produces better protocol adherence.

**2. Kiro is significantly faster**
Kiro completes the same workflow in half the time with equivalent code quality. The Kiro execution model (sequential turns with human-in-the-loop gates) is more efficient for straightforward tasks.

**3. Both pass all contract and code quality checks**
88/88 contract endpoints pass in both modes. Zero lint and security findings in both. The generated API implementations are functionally correct regardless of execution mode.

**4. The empty-questions pattern is a src-level issue**
Kiro's lower qualitative score on questions files (0.18, 0.16) is not an execution mode problem — it's the builder skipping clarification when the intent is detailed. This affects both modes but is more pronounced in Kiro runs. See [ISSUES.md ISSUE-007](../ISSUES.md).

**5. Token efficiency favours Kiro**
Raw Rules consumed 10.5M unique tokens and 80.9M total API tokens (7.7× multiplier from context re-sending across 45 handoffs). Kiro token usage is not metered but is structurally lower due to single-session execution.

---

## Run Details

| | Kiro | Raw Rules |
|--|------|-----------|
| Run folder | `runs/20260521T183159-aidlc-workflows_v2-kiro-cli/` | `runs/parallel-test/20260521T183159-local_aidlc-workflows-v2/` |
| Full report (MD) | `report.md` | `report.md` |
| Full report (HTML) | `report.html` | `report.html` |
| Started | 2026-05-21T18:59:33Z | 2026-05-21T18:31:59Z |
| Execution mode | Kiro IDE (native sub-agents) | Strands swarm (4 agents) |
| Rules delivery | `.kiro/` distribution (dist/kiro) | `src/` (local copy) |
