# Test Specification

> Minimum structure. Sections may be omitted with rationale or extended as needed.

## Unit Tests

Tests for individual methods/functions in isolation.

### [Component / Module Name]

| ID | Test Case | Traces to | Given | When | Then |
|---|---|---|---|---|---|
| TC-001 | [short description] | [BR-n / NFR-n] | [precondition] | [action] | [expected outcome] |

## Component Tests

Tests for complete call chains within the unit (multiple methods working together).

### [Flow / Feature Name]

| ID | Test Case | Traces to | Given | When | Then |
|---|---|---|---|---|---|
| TC-050 | [short description] | [BR-n / NFR-n] | [precondition] | [action] | [expected outcome] |

## Integration Tests

Tests for interactions with external dependencies and other units (via contracts).

### [Integration Boundary]

| ID | Test Case | Traces to | Given | When | Then |
|---|---|---|---|---|---|
| TC-100 | [short description] | [BR-n / NFR-n / Contract C-n] | [precondition] | [action] | [expected outcome] |

## NFR Tests

Tests derived from non-functional requirements (performance, security, availability).

### [Quality Attribute]

| ID | Test Case | Traces to | Given | When | Then |
|---|---|---|---|---|---|
| TC-150 | [short description] | [NFR-n] | [precondition / load condition] | [action] | [expected measurable outcome] |

## Coverage Matrix

| Rule / NFR | Test Cases | Tier |
|---|---|---|
| BR-001 | TC-001, TC-051 | unit, component |
| NFR-1 | TC-150 | nfr |
