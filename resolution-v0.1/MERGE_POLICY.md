# Resolution v0.1 Merge Policy

Policy version: 0.1.0

This policy applies Resolution to the pull request carrying Resolution v0.1.

## Basis

For the exact merge candidate:

\`\`\`text
C = base commit SHA
E = executable conformance corpus result
    + qualifying external falsification review(s)
P = this merge policy and FALSIFICATION_REVIEW.md
A = repository merge authority as enforced by GitHub
T = exact head commit SHA -> exact base commit SHA
\`\`\`

The policy does not expand GitHub authority. It only states when this research artifact regards its exact candidate transition as resolved.

## Results

\`UNAUTHORIZED\` if:
- the conformance corpus does not match its committed expected states; or
- a qualifying current-head review reports \`COUNTEREXAMPLE\`.

\`UNRESOLVED\` if:
- the conformance corpus passes but no qualifying external falsification review is anchored to the current head; or
- the evidence required by this policy cannot be reconstructed.

\`AUTHORIZED\` if:
- the conformance corpus passes;
- at least one qualifying external current-head review reports \`NO_COUNTEREXAMPLE\`; and
- no qualifying external current-head review reports \`COUNTEREXAMPLE\`.

## Effectuation closure

An \`AUTHORIZED\` receipt is not bearer authority.

If the head SHA, base SHA, merge policy, falsification protocol, or conformance corpus changes before merge, the earlier receipt remains evidence but the transition MUST be re-resolved.

\`\`\`text
AUTHORIZED(B_n,T) != AUTHORIZED(B_m,T)
\`\`\`

whenever a load-bearing basis component changed.

The actual merge remains governed by GitHub repository permissions and any branch/ruleset controls. This policy does not claim to make a bypassable repository setting non-bypassable.
