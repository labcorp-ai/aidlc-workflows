# Test Design Stage — Summary

## What it is

- A specification stage that produces English-language test cases, not test code
- Sits after NFR design (has both functional spec and quality targets to draw from)
- Feeds into code-generation as acceptance criteria ("am I done?")

## What it produces

- Tiered test cases: unit-level (method does X), component-level (call chain within unit), integration-level (cross-unit)
- Each test case traces to a business rule (BR-n) or NFR target (NFR-n)
- Reviewable by product people — plain English, not framework-specific code

## Two consumers of the same artifact

- **Code-generation** — uses test cases as guardrails during development (TDD-like guidance)
- **QA team / test-code-gen** — uses test cases to write independent test code on their own machine

## Future fork (next iteration)

- Test-design becomes the last shared stage
- Road splits: code-gen track (production code) and test-code-gen track (verification code) run in parallel
- Both guided by the same test design document

## Traceability chain

- Requirement (FR/NFR) → Business Rule (BR-n) → Test Case (TC-n) → Code

## Current flow

```
functional-design → nfr-design → test-design → infrastructure-design → code-generation
```

## Future flow

```
functional-design → nfr-design → test-design → infrastructure-design ─┬─→ code-generation
                                                                       └─→ test-code-generation (parallel)
```
