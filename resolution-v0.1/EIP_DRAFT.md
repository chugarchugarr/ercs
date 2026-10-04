---
title: Resolution of Authority Transitions
description: Defines an invariant preventing evidence, validity, or computation from self-authorizing consequential state transitions.
author: Joseph Angel Lerma (@chugarchugarr)
discussions-to: https://ethereum-magicians.org/t/eip-tbd-resolution-non-self-authorizing-state-transitions/29846
status: Draft
type: Informational
created: 2026-10-03
---

## Abstract

This EIP defines Resolution, a mechanism-neutral design invariant for consequential state transitions. A valid proof, computation, credential, identity, provenance record, historical authorization, or candidate transition does not acquire authority over a successor state merely by existing or validating. Systems applying Resolution derive authority for an exact proposed transition from admitted evidence, a committed procedure or policy, current authority, and the canonical predecessor state, producing `AUTHORIZED`, `UNAUTHORIZED`, or `UNRESOLVED`. Authorization must remain bound to the basis under which it was derived through effectuation; an earlier `AUTHORIZED` result is not itself durable authority.

## Motivation

Ethereum increasingly composes recovery systems, autonomous agents, delegation, provenance, proof aggregation, auctions, account lifecycle rules, and other mechanisms that produce valid artifacts capable of influencing consequential state.

These mechanisms can fail even when every artifact verifies correctly if an uncommitted input changes which artifact becomes authoritative, a historical authorization is treated as current authority, a valid proof is applied to a different scope, or a resolution decision is executed after its load-bearing basis changed.

## Specification

For a consequential transition `T`, define:

```text
Resolve(currentState, evidence, procedure, authority, proposedTransition)
    -> AUTHORIZED
     | UNAUTHORIZED
     | UNRESOLVED
```

`UNRESOLVED` MUST NOT be collapsed into an authoritative answer merely because an implementation requires a binary result. An explicit default-deny rule MAY convert the operational consequence to rejection if that rule is part of the committed procedure.

### Evidence and authority

```text
E_n ⊆ E_(n+1)
```

does not imply:

```text
A_n ⊆ A_(n+1)
```

A valid object `X` MUST NOT be treated as authoritative for consequence `Y` unless the current procedure establishes the authority edge from `X` to `Y`.

### Exact transition binding

Authorization for one proposed transition MUST NOT authorize a substituted transition unless the substitution rule is itself part of the committed procedure.

### Outcome-relevant closure

Every input or transformation capable of changing the authoritative successor MUST either be committed inside the Resolution procedure or explicitly defined as external and incapable of changing the protected authoritative result.

### Composition

Composition MUST be authority-non-expansive.

### Temporal authority

A historically valid signature, credential, delegation, owner relation, recovery commitment, approval, or Resolution result MUST NOT be treated as current authority solely because its authenticity remains verifiable.

### Effectuation closure

`AUTHORIZED` is not equivalent to an effective canonical successor.

If a load-bearing part of the Resolution basis changes between authorization and effectuation, the protected transition MUST either be re-resolved against the current basis or rejected, unless Resolution and effectuation were atomic with respect to that basis.

An authorization receipt is evidence of the earlier decision and MUST NOT be treated as self-renewing authority.

### Canonical authority state

A system MUST preserve enough authority state to distinguish future continuations that its procedure would resolve differently.

Two histories MUST NOT be collapsed into the same canonical authority state if an admissible future continuation can cause different Resolution outcomes solely because of authority information erased by that collapse.

### Translation

Where a protected transition crosses representation layers, a lower layer MUST NOT acquire authority to create a protected consequence absent from the resolved higher-level relation unless that expansion is independently authorized.

## Rationale

The EIP is mechanism-neutral because the correct closure mechanism depends on the state machine. The explicit `UNRESOLVED` state prevents incomplete evidence from being converted into authority by an implementation forced to choose. Separating authorization from effectuation prevents an otherwise correct Resolution decision from becoming stale authority.

## Backwards Compatibility

This EIP changes no Ethereum protocol rules by itself.

## Test Cases

| Case | Expected result |
| --- | --- |
| Valid historical authority, current revocation omitted by an uncommitted history prefix | Open boundary |
| Valid evidence with no authority edge to the claimed consequence | `UNRESOLVED` or `UNAUTHORIZED` according to policy |
| Valid proof whose committed scope differs from the target package | Reject |
| Authorization for `T`, execution attempts `T'` | Reject |
| Two valid components compose into authority supplied by neither component nor policy | Reject |
| `AUTHORIZED` at authority epoch `n`, execution after authority epoch changes | Re-resolve or reject |
| Two histories canonicalize identically but the same future revocation requires different answers | Canon insufficient |
| Lower-level implementation can produce a protected effect absent from source authority | Translation boundary open |

## Security Considerations

Resolution does not establish that the governing policy is wise, fair, or legitimate. Resolver compromise and evidence admission remain separate security boundaries. Systems that omit `UNRESOLVED` risk manufacturing authority by forcing a conclusion unsupported by the admitted basis. The authorization-to-effectuation interval is a critical attack surface.

## Copyright

Copyright and related rights waived via CC0.
