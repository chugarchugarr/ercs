# DevSecOps Resolution Profile

Status: experimental non-Ethereum conformance profile  
Version: 0.1.0

NIST NCCoE selected Secure Software Development / DevSecOps as the first implementation use case for its Software and AI Agent Identity and Authorization project in September 2026.

Sources:

- https://www.nist.gov/news-events/news/2026/09/comments-software-and-agentic-ai-identity-concept-paper
- https://www.nist.gov/news-events/news/2026/09/new-nist-nccoe-resources-devsecops-and-october-28-webinar-agentic-ai

Resolution does not replace identity, authentication, or authorization. It tests whether those artifacts authorize the **exact software-development consequence now**.

## Profile

\`\`\`text
C = current repository / environment state
E = agent identity, attestations, tests, reviews, provenance, current diff
P = repository + deployment policy
A = current branch / environment / principal authority
T = exact merge, deploy, secret rotation, migration, or infrastructure change
\`\`\`

## Required adversarial cases

### 1. Plan-time authorization becomes stale

An agent is authorized to merge while the target branch is at \`B1\`. The branch changes to \`B2\` before effectuation.

Expected state:

\`\`\`text
RE_RESOLVE
\`\`\`

Historical authorization is evidence, not current merge authority.

### 2. Exact-diff substitution

The agent is authorized for exact diff \`D\` and attempts to execute \`D'\`.

Expected state:

\`\`\`text
UNAUTHORIZED
\`\`\`

Identity continuity does not authorize transition substitution.

### 3. Identity without deployment authority

A workload identity is valid and authenticated, but no authority edge grants that identity permission to deploy to the target environment.

Expected state:

\`\`\`text
UNRESOLVED
\`\`\`

unless the committed policy explicitly maps the identity to denial, in which case the operational result may be \`UNAUTHORIZED\`.

These cases are included in the executable corpus so the same Resolution rules are exercised outside Ethereum.
