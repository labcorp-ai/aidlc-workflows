# Test Design

## Description

Produce a complete English-language test specification covering all tiers: unit tests, component tests, and integration tests. Each test case traces to a business rule or NFR target. This artifact serves two purposes — it guides code-generation as acceptance criteria, and it provides the QA team (or a future test-code-generation track) with an independent test plan.

## Inputs

- **Required:** `functional-spec.md` + `rules.yaml` + `entities.yaml` from functional-design, `nfr-specification.md` from nfr-design
- **Optional context:** Contracts from contract-design (for integration-level test cases), `components.yaml` from domain-design

## Outputs

Artifacts this stage can produce. The owner's plan determines which are relevant. Additional artifacts may be produced if warranted.

- `test-specification.md` — English-language test cases organised by tier (unit, component, integration) with traceability to rules and NFRs

## Owner

aidlc-systems-architect-agent

## Contributors

- aidlc-product-manager-agent: validate test cases cover acceptance criteria from stories

## Reviewer

aidlc-architecture-reviewer-agent
