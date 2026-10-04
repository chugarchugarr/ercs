# Upstream EIP handoff

Target repository: `ethereum/EIPs`

Proposed initial path:

```text
EIPS/eip-draft_resolution.md
```

Source file in this package: `EIP_DRAFT.md`

Author line MUST remain:

```text
author: Joseph Angel Lerma (@chugarchugarr)
```

Discussion thread:

```text
https://ethereum-magicians.org/t/eip-tbd-resolution-non-self-authorizing-state-transitions/29846
```

This is an **Informational** EIP. Do not add a Standards Track `category` field.

Suggested PR title:

```text
Add Informational EIP: Resolution of Authority Transitions
```

Suggested PR body:

```text
Introduces a mechanism-neutral design invariant for consequential state transitions: evidence, validity, computation, identity, provenance, and prior authorization do not self-authorize an exact successor state.

The draft defines:
- Resolve(C,E,P,A,T) -> AUTHORIZED | UNAUTHORIZED | UNRESOLVED
- evidence/authority non-inheritance
- exact-transition binding
- outcome-relevant closure
- authority-non-expansive composition
- temporal authority
- effectuation closure (AUTHORIZED != CANON)
- residual authority / Canon future-sufficiency
- translation authority preservation

Discussion:
https://ethereum-magicians.org/t/eip-tbd-resolution-non-self-authorizing-state-transitions/29846

Joseph Angel Lerma (@chugarchugarr) remains the listed author and has prepared/approved the submitted text. The submitter is carrying the repository transport because the author currently cannot fork ethereum/EIPs from his GitHub account.
```

The submitter should not add themselves as an author unless they materially co-author the proposal and the listed author agrees. Repository transport and EIP authorship are separate.
