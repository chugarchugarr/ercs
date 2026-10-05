# External Falsification Review Protocol

Version: 0.1.0

Resolution v0.1 does not treat author self-review as independent evidence for the general invariant.

A qualifying external falsification review is a GitHub pull-request review:

1. submitted by an account other than the pull-request author;
2. anchored by GitHub to the current head commit;
3. explicitly testing at least one frozen boundary; and
4. using exactly one unambiguous machine-readable block below for a `NO_COUNTEREXAMPLE` claim. A review containing any `COUNTEREXAMPLE` result is non-authorizing and the counterexample dominates any clean claim in the same review.

## Review block

\`\`\`text
RESOLUTION-FALSIFICATION v0.1
boundary: OUTCOME_RELEVANT_CLOSURE | EFFECTUATION_CLOSURE | CANON_FUTURE_SUFFICIENCY
result: NO_COUNTEREXAMPLE | COUNTEREXAMPLE
fixture: <path, URL, or NONE>
\`\`\`

\`NO_COUNTEREXAMPLE\` means only that the reviewer attempted the stated falsifier against the exact reviewed commit and did not find a counterexample. It is not proof of the general law.

\`COUNTEREXAMPLE\` means the exact reviewed commit is not authorized for merge under the v0.1 merge policy until the counterexample is either represented as a fixture and the specification narrowed/fixed, or shown not to satisfy the stated falsifier.

Multiple or contradictory clean-result blocks MUST NOT create authority. If parsing is ambiguous and no `COUNTEREXAMPLE` is present, the review is non-qualifying and the gate remains `UNRESOLVED` absent other qualifying evidence.

A review attached to an older head commit loses authority when the candidate head changes. It remains historical evidence.

This is deliberate:

\`\`\`text
VALID_REVIEW(head_n) != CURRENT_REVIEW_AUTHORITY(head_n+1)
\`\`\`
