<!--
Copyright © 2026 Joseph Angel Lerma.
Licensed under CC BY 4.0. See LICENSE.md.
-->

# Resolution v0.1 — Non-Self-Authorizing State Transitions

Status: Experimental Research Specification  
Version: 0.1.0  
Date: 2026-10-04

## 1. Purpose

Many systems correctly prove or compute an object and then silently let that object acquire more authority than the proof or computation established.

Resolution defines the boundary between producing a candidate or evidence and authorizing an exact consequential successor transition.

## 2. Primitive

For a consequential transition `T`:

```text
Resolve(C, E, P, A, T)
  -> AUTHORIZED
   | UNAUTHORIZED
   | UNRESOLVED
```

- `C`: canonical predecessor state.
- `E`: admitted evidence.
- `P`: committed procedure or policy.
- `A`: the authority relation applicable to the proposed action and scope at its effective time, evaluated from the current evidence/knowledge state; it includes residual authority state required to distinguish future outcomes.
- `T`: exact proposed consequential transition.

`AUTHORIZED` establishes authority for exactly `T` under the current basis.  
`UNAUTHORIZED` means the procedure establishes that `T` may not become effective.  
`UNRESOLVED` means the admitted basis does not establish an authorized successor.

`UNRESOLVED` MUST NOT be collapsed into an authoritative answer merely because an implementation requires a binary result. An explicit default-deny rule may exist, but if it controls consequence it is part of `P`.

The Resolution basis is:

```text
B = (C, E, P, A, T)
```

Authority is not a timeless property of an object. Its complete form is a
scoped relation evaluated from a knowledge state:

```text
A_tau(S, action, scope, t)
  -> TRUE
   | FALSE
   | UNRESOLVED
```

- `t` is effective/valid time: when the authority relation is claimed to apply.
- `tau` is evidence/knowledge time: the admitted evidentiary state from which
  that historical or present authority claim is evaluated.

A transition is permitted only when presently admitted evidence establishes
`TRUE` for the exact action, scope, and effective time. A fact learned now
about authority at an earlier effective time does not by itself authorize an
action now.

## 3. Invariants

### R1 — Evidence accumulation does not propagate authority

Evidence may accumulate across knowledge time:

```text
E_tau1 ⊆ E_tau2
```

That does not make authority an accumulating property. Authority must be
established for its particular action, scope, and effective time under the
current knowledge state.

```text
A_tau1(S, action, scope, t) = TRUE
does not imply
A_tau2(S, action, scope, t_now) = TRUE
```

The earlier "evidence monotonic, authority non-monotonic" observation is
therefore derived from temporal scoping; it is not the primitive law.
Preserving evidence MUST NOT by itself preserve, restore, or expand its former
authority.

### R2 — Validity is not authority

```text
VALID(X) != AUTHORITATIVE_FOR(Y)
```

unless the current Resolution basis establishes the authority edge from `X` to `Y`.

### R3 — Exact transition binding

Authorization for `T` MUST NOT authorize substituted transition `T'` unless the substitution rule is itself part of `P`.

### R4 — Outcome-relevant closure

Every input or transformation capable of changing the authoritative successor MUST either be committed inside the Resolution basis or explicitly external and incapable of changing the protected authoritative result.

Falsifier:

```text
hold every committed Resolution input fixed
vary one uncommitted outcome-relevant input
if the authorized successor changes:
    boundary = OPEN
```

### R5 — Composition is authority-non-expansive

Combining valid objects MUST NOT create authority absent from the inputs and absent from an already-authorized composition rule.

```text
A_out ⊆ A_inputs ∪ A_explicitly_granted_by_P
```

### R6 — Temporal authority

Authority is a scoped relation at an effective time, not a property inherited
through history.

```text
A_tau2(S, action, scope, t0) = TRUE
does not imply
A_tau2(S, action, scope, t2) = TRUE
```

Likewise, learning that a successor lacked authority at an earlier time does
not reactivate its predecessor now. Historical authority is evidence about
historical authority. A previously valid or authorized object MUST NOT be
treated as current authority merely because it remains authentic or
historically valid.

### R7 — Effectuation closure

```text
AUTHORIZED(B_n, T) does not imply AUTHORIZED(B_m, T)
```

when a load-bearing part of the basis changed between Resolution and effectuation.

A protected transition may become effective only when Resolution and commit are atomic with respect to the load-bearing basis, the implementation verifies that the basis remains applicable at effectuation, or the transition is re-resolved against the current basis.

For a non-atomic transition, the effectuation check MUST bind the complete
load-bearing Resolution basis (or a commitment to it), not a selected
projection. Because `E` is part of `B`, a change in admitted evidence alone
requires re-resolution whenever that evidence can affect authority.

An authorization receipt is evidence of the earlier decision. It is not self-renewing authority.

### R8 — Canon future-sufficiency

Two histories may collapse into the same canonical authority state only if no admissible future continuation can require different Resolution outcomes solely because of information discarded by that collapse.

If:

```text
Canon(H1) == Canon(H2)
```

then for every admissible future continuation `F` relevant to the protected authority relation:

```text
Resolve(H1 + F) == Resolve(H2 + F)
```

If a counterexample exists, Canon discarded future-distinguishing authority state.

### R9 — Translation is authority-preserving

For a protected consequence, translation across representation layers MUST NOT create authority or permitted consequential behavior absent from the resolved source relation unless the expansion is independently authorized.

```text
A(tau(x)) ⊆ A(x) ∪ A_explicitly_granted
```

This applies whether the layers are natural language, formal specification, program, IR, machine code, hardware capability, actuator instruction, or another representation.

## 4. Canon closure

Resolution does not end at the word `AUTHORIZED`.

```text
candidate
  -> Resolve(B, T)
  -> AUTHORIZED
  -> effectuation check / atomic commit
  -> Canon'
```

Therefore:

```text
AUTHORIZED != CANON
```

**Canon closes Resolution.**

A failed or stale Resolution attempt remains evidence. It MUST NOT silently advance authority.

## 5. Residual authority

Some authority systems are path-dependent. Two histories can expose the same current permission relation while reacting differently to the same future revocation, delegation, or lifecycle event.

A conforming implementation MUST preserve enough authority state to distinguish every future continuation that `P` treats differently.

## 6. Machine capability

Resolution does not require candidate generation to be bounded by a list of human-anticipated answers.

A system MAY permit open-ended search, planning, model inference, scientific hypothesis generation, or other candidate generation.

The candidate generator MUST NOT acquire authority over a protected consequence merely by producing the candidate.

```text
CAPABILITY != AUTHORITY
```

The human or governing protocol need not enumerate every answer. It must define or delegate the relation under which a discovered answer may become consequential.

## 7. Conformance

At minimum, a Resolution test suite SHOULD include stale authority, an uncommitted outcome-relevant selector, exact-transition substitution, evidence overclaim, composition authority expansion, Resolution-to-effectuation state change, canonicalization that erases future-distinguishing authority history, translation that introduces a lower-level protected consequence absent from source authority, and a valid `UNRESOLVED` case.

## 8. Security considerations

Resolution does not make an untrusted resolver trustworthy. The procedure must specify which resolver, proof, quorum, monitor, or mechanism is authoritative.

Systems that cannot represent `UNRESOLVED` can manufacture authority by forcing a choice unsupported by the basis.

A deterministic and closed Resolution procedure can still authorize a harmful transition. Conformance establishes closure, not wisdom, fairness, legitimacy, or safety of the policy itself.

Evidence provenance, independence, freshness, completeness, and acquisition boundaries remain separate problems.

## 9. Falsifiability

A counterexample narrows or defeats a rule if all load-bearing basis inputs are fixed, no additional authority edge exists, and yet an uncommitted or unauthorized dependency can change protected consequential state while the resulting transition remains legitimately authorized under the claimed procedure.

Such a counterexample should be preserved as a fixture rather than explained away.
