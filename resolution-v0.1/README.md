# Resolution v0.1

**Non-Self-Authorizing State Transitions**

Resolution is a mechanism-neutral specification for separating evidence, validity, computation, identity, provenance, and candidate generation from the authority to make an exact consequential transition effective.

```text
Resolve(C, E, P, A, T)
  -> AUTHORIZED
   | UNAUTHORIZED
   | UNRESOLVED
```

The foundational law is:

```text
Authority is a scoped relation at an effective time,
evaluated from a knowledge state.

A_tau(S, action, scope, t) -> TRUE | FALSE | UNRESOLVED
```

Evidence may accumulate across knowledge time. Authority does not propagate
across effective time merely because history was preserved.

The closure law is:

```text
AUTHORIZED != CANON
```

A Resolution verdict is evidence that a transition was authorized under a particular basis. It is not durable authority by itself. The protected effect may become Canon only if it is committed against a still-applicable Resolution basis, or Resolution and commit are atomic under the governing procedure.

## Contents

- `SPEC.md` — standalone Resolution v0.1 specification.
- `EIP_DRAFT.md` — Informational EIP-shaped draft.
- `RELATED_WORK.md` — adjacent work and evidence map.
- `conformance/runner.py` + `conformance/fixtures.json` — executable adversarial corpus (14 fixtures).
- `conformance/pr_gate.py` — self-applying Resolution gate for the carrying PR.
- `FALSIFICATION_REVIEW.md` — machine-readable independent falsification protocol.
- `MERGE_POLICY.md` — exact basis and result rules for the carrying PR.
- `DEVSECOPS_PROFILE.md` — first non-Ethereum profile, aligned to NIST's 2026 DevSecOps agent-authorization use case.
- `RELEASE_NOTES.md` — release/archival boundary.
- `CITATION.cff` — citation metadata.

## Run

```bash
python resolution-v0.1/conformance/runner.py resolution-v0.1/conformance/fixtures.json
```

This is a research specification. It makes no claim that authorization, reference monitoring, capabilities, provenance, formal semantics, runtime assurance, or state-machine safety originated here. The contribution is the explicit cross-domain invariant, tri-state closure, effectuation rule, Canon rule, and executable falsification corpus.

```text
Possibility may expand.
Authority does not expand merely because possibility, evidence, or representation expanded.
Only a resolved transition may become Canon.
```


## Authorship and license

Resolution v0.1 is authored by **Joseph Angel Lerma (@chugarchugarr)**.

Copyright © 2026 Joseph Angel Lerma.

The standalone specification and documentation are licensed under **CC BY 4.0**. The executable conformance code and fixtures are licensed under **MIT**. The Ethereum-specific `EIP_DRAFT.md` is separately dedicated under **CC0 1.0** for EIP-process compatibility.

See `LICENSE.md` for the exact file-level split.


## Self-application

The pull request carrying v0.1 is itself treated as a consequential transition.

A GitHub Action reconstructs the exact base/head basis, executes the conformance corpus, checks for an external falsification review anchored to the current head, and emits a non-bearer \`resolution-receipt.json\`.

The receipt becomes stale if a load-bearing basis component changes. This is an implementation of \`AUTHORIZED != CANON\`, not a claim that the receipt itself carries merge authority.
