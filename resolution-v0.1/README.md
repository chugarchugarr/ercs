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
E_n ⊆ E_(n+1)  does not imply  A_n ⊆ A_(n+1)
```

The closure law is:

```text
AUTHORIZED != CANON
```

A Resolution verdict is evidence that a transition was authorized under a particular basis. It is not durable authority by itself. The protected effect may become Canon only if it is committed against a still-applicable Resolution basis, or Resolution and commit are atomic under the governing procedure.

## Contents

- `SPEC.md` — standalone Resolution v0.1 specification.
- `EIP_DRAFT.md` — Informational EIP-shaped draft.
- `RELATED_WORK.md` — adjacent work and evidence map.
- `conformance/runner.py` + `conformance/fixtures.json` — executable adversarial corpus.
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
