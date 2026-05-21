# AIDLC Evaluator — v1 vs v2 Comparison

> **Date:** 2026-05-21
> **Scenario:** Scientific Calculator REST API (greenfield)
> **Model:** `global.anthropic.claude-opus-4-6-v1` (all runs)
> **v1 branch:** `main` · **v2 branch:** `v2-evaluator`

Three execution modes evaluated against the same sci-calc benchmark:

| Mode | Description |
|------|-------------|
| **v1** | Single executor + human simulator (2-agent Strands swarm). Rules loaded from `aidlc-rules/` (v1 flat structure). Evaluated against v1 golden. |
| **v2 Raw Rules** | 4-agent Strands swarm (orchestrator → builder → validator → simulator). Rules loaded from `src/` (v2 skills/protocols). `process_checker.js` enforced via `ProcessCheckerHook`. Evaluated against v2 golden. |
| **v2 Kiro** | Kiro IDE with v2 `.kiro/` distribution. Native sub-agents, `process_checker.js` enforced via hook after every sub-agent call. Evaluated against v2 golden. |

---

## Verdict

| Dimension | v1 | v2 Raw Rules | v2 Kiro |
|-----------|---:|-------------:|--------:|
| **Qualitative score** | 🟡 0.80 | 🟢 **0.86** | 🟡 0.74 |
| **Unit tests** | ✅ 220/220 | ✅ **348**/348 | ✅ 124/124 |
| **Contract tests** | ✅ 88/88 | ✅ 88/88 | ✅ 88/88 |
| **Lint warnings** | ✅ 0 | ✅ 0 | ✅ 0 |
| **Security findings** | ✅ 0 | ✅ 0 | ✅ 0 |
| **Wall clock** | 🏆 **15 min** | 60 min | 28 min |
| **Unique tokens** | 4.7M | 10.5M | N/A |
| **Repeated context** | 4.6M | 80.9M | N/A |
| **Handoffs** | 3 | 45 | 20 turns |

---

## Speed & Efficiency

| Metric | v1 | v2 Raw Rules | v2 Kiro |
|--------|---:|-------------:|--------:|
| Wall clock | **15 min** | 60 min | 28 min |
| Handoffs / turns | 3 handoffs | 45 handoffs | 20 turns |
| Unique tokens | 4.7M | 10.5M | N/A |
| Repeated context tokens | 4.6M | 80.9M | N/A |
| Unit tests generated | 220 | **348** | 124 |

v1 is fastest by far — 3 handoffs and 15 minutes. Its 2-agent architecture (executor + simulator) has minimal overhead. v2 Raw Rules is 4× slower due to the 4-agent swarm and 45 handoffs, though the sliding window `conversation_manager` reduces per-agent context. v2 Kiro sits in between at 28 minutes.

The repeated context token spike in v2 Raw Rules (80.9M vs 4.6M for v1) reflects the cost of re-sending conversation history across 45 Strands swarm handoffs.

---

## Code Quality

All three runs produced functionally correct code passing all contract and quality checks.

| Metric | v1 | v2 Raw Rules | v2 Kiro |
|--------|---:|-------------:|--------:|
| Unit tests | 220/220 (100%) | **348**/348 (100%) | 124/124 (100%) |
| Contract tests | 88/88 | 88/88 | 88/88 |
| Lint errors | 0 | 0 | 0 |
| Lint warnings | 0 | 0 | 0 |
| Security high | 0 | 0 | 0 |

v2 Raw Rules generates the most unit tests (348), reflecting the richer construction phase with functional design, NFR assessment, and code generation feeding into more comprehensive test coverage. v1 (220) beats v2 Kiro (124) despite using an older architecture.

---

## Qualitative Score (Document Quality vs Golden)

> Note: v1 is scored against the v1 golden master; v2 modes are scored against the v2 golden master. Phase structures differ between versions.

### Overall

| Phase | v1 | v2 Raw Rules | v2 Kiro |
|-------|---:|-------------:|--------:|
| **Overall** | 0.7983 | **0.8622** | 0.7429 |
| Inception | **0.8566** | 0.8525 | 0.6447 |
| Construction | 0.7400 | **0.8480** | 0.5793 |
| Bootstrap | — | **0.9432** | 0.8725 |
| Other | — | 0.8050 | **0.8750** |

### Per-Document Breakdown

#### v1 — Inception Phase

| Document | Score |
|----------|------:|
| `application-design/component-dependency.md` | 0.95 |
| `application-design/component-methods.md` | 0.96 |
| `application-design/components.md` | 0.95 |
| `application-design/services.md` | 0.87 |
| `plans/execution-plan.md` | 0.96 |
| `requirements/requirements.md` | 0.93 |
| `requirements/requirement-verification-questions.md` | 0.38 |

v1 inception scores are high across application design (0.87–0.96) but the requirement-verification-questions file scores only 0.38 — the same empty-questions pattern seen in v2 Kiro.

#### v1 — Construction Phase

| Document | Score |
|----------|------:|
| `plans/sci-calc-code-generation-plan.md` | **0.88** |
| `build-and-test/build-and-test-summary.md` | 0.74 |
| `build-and-test/build-instructions.md` | 0.77 |
| `build-and-test/unit-test-instructions.md` | 0.73 |
| `build-and-test/integration-test-instructions.md` | 0.58 |

v1 uniquely produces build-and-test documentation (a skill not yet in v2 golden). Integration test instructions score lowest (0.58).

#### v2 Raw Rules — Bootstrap Phase

| Document | Score |
|----------|------:|
| `bootstrap-context.md` | 1.00 |
| `intent-bootstrap-questions.md` | 0.89 |
| `workflow-composition/validation-report.md` | 0.93 |
| `workflow-composition-questions.md` | 0.94 |
| `workflow-rationale.md` | 0.96 |

The v2 bootstrap phase — new to v2 — scores exceptionally well. The explicit intent capture, workflow composition, and rationale documents are high quality across all runs.

#### v2 Raw Rules — Inception Phase

| Document | Score |
|----------|------:|
| `requirements-analysis-plan.md` | 0.88 |
| `requirements-analysis-questions.md` | **0.77** |
| `requirements.md` | 0.94 |
| `validation-report.md` | 0.83 |

v2 Raw Rules generates substantive clarification questions (0.77) while v2 Kiro (0.18) and v1 (0.38) both skip most clarification. The multi-agent architecture with explicit builder/validator separation appears to improve question generation.

#### v2 Kiro vs v2 Raw Rules — Questions Gap

| Questions document | v2 Kiro | v2 Raw Rules |
|-------------------|--------:|-------------:|
| `requirements-analysis-questions.md` | 0.18 | **0.77** |
| `code-generation-questions.md` | 0.16 | — |

This is the largest per-document gap in the comparison. See [ISSUES.md ISSUE-007](../../ISSUES.md).

---

## Key Observations

**1. v2 Raw Rules produces the highest quality documentation**
At 0.86 overall, v2 Raw Rules outperforms both v1 (0.80) and v2 Kiro (0.74). The 4-agent swarm with explicit builder/validator separation generates richer artifacts — more questions, validation reports, and more detailed plans.

**2. v1 is fastest and most token-efficient**
15 minutes, 3 handoffs, 4.7M tokens. The 2-agent architecture remains the most efficient execution model. v2 adds quality at the cost of 4× more time and 2× more tokens (Raw Rules).

**3. All three pass all code quality checks**
88/88 contract tests, zero lint errors, zero security findings across all runs. The generated API is functionally correct regardless of version or execution mode.

**4. v2 introduces a new bootstrap phase not in v1**
Intent capture, workflow composition, and rationale are new v2 artifacts scoring 0.87–0.94. These provide traceability and intent preservation that v1 lacks entirely.

**5. The questions/clarification gap is consistent across all modes**
v1 (0.38), v2 Kiro (0.18), v2 Raw Rules (0.77). Only v2 Raw Rules reliably generates substantive clarification questions. The empty-questions pattern in v1 and v2 Kiro is a src-level protocol issue — see [ISSUES.md ISSUE-007](../../ISSUES.md).

**6. v2 construction quality exceeds v1**
v2 Raw Rules construction scores 0.848 vs v1's 0.740. The additional upstream context from requirements-analysis, NFR assessment, and functional design feeds into higher-quality code generation plans.

---

## Run Details

| | v1 | v2 Raw Rules | v2 Kiro |
|--|----|-----------|----|
| Repo | `aidlc-workflows` (main) | `aidlc-workflows-v2` (v2-evaluator) | `aidlc-workflows-v2` (v2-evaluator) |
| Run folder | `runs/v1-comparison/20260521T212827-aidlc-workflows_main/` | `runs/parallel-test/20260521T183159-local_aidlc-workflows-v2/` | `runs/20260521T183159-aidlc-workflows_v2-kiro-cli/` |
| Full report (MD) | `report.md` | `report.md` | `report.md` |
| Full report (HTML) | `report.html` | `report.html` | `report.html` |
| Execution mode | 2-agent Strands swarm | 4-agent Strands swarm | Kiro IDE (native sub-agents) |
| Rules delivery | `aidlc-rules/` (git clone, main) | `src/` (local, v2-evaluator) | `.kiro/` distribution |
| Golden | v1 sci-calc golden | v2 sci-calc-v2 golden | v2 sci-calc-v2 golden |
