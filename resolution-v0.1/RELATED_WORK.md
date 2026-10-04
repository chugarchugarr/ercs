# Related Work and Evidence Map

This document states only the relation each source establishes. Citation or conceptual proximity is not treated as proof of derivation, priority, or collaboration.

## Ethereum Resolution thread

The public discussion states the distinction between computation, evidence, validity, and authority; defines `AUTHORIZED | UNAUTHORIZED | UNRESOLVED`; gives the evidence-monotonicity/authority-non-monotonicity law; and proposes the uncommitted-input falsifier.

https://ethereum-magicians.org/t/eip-tbd-resolution-non-self-authorizing-state-transitions/29846

## Procedure Manifests

The project accepted a closure counterexample and records adoption of a Judge Result Contract, first-class `UNRESOLVED`, a normative state machine, semantic replay/conformance, evidence provenance pins, and removal of self-reported confidence from contractual authority.

Relation: executable evidence that nondeterministic cognition can remain evidence while contractual authority is defined by a separately committed projection and state machine.

https://ethereum-magicians.org/t/rfc-procedure-manifests-mechanism-for-ai-agents-to-resolve-contractual-disputes/29563

## ERC-8434 Agent Identity (AID)

AID defines authority intervals; re-establishing the relation never authorizes the gap.

Relation: evidence persistence does not imply continuous authority.

https://ethereum-magicians.org/t/erc-8434-agent-identity-aid/29805

## EIP-8425 quantum recovery

The discussion separates freeze, evidence, resolution, and successor authority.

Relation: compromised predecessor credentials cannot self-authorize successor authority.

https://ethereum-magicians.org/t/eip-8425-quantum-freeze-and-account-recovery/29770

## EIP-8288 PQ signature and STARK aggregation

A valid proof of dependency set `D` is not authoritative for package `P` unless `D` equals the canonical dependencies of `P`.

Relation: proof validity is not authority over an unstated or substituted scope.

https://ethereum-magicians.org/t/eip-8288-frame-type-for-pq-sig-and-stark-aggregation/28723

## ERC-8403 Account Authority Lifecycle

All signed lifecycle entries can be valid while an uncommitted history prefix changes which key appears authoritative.

Relation: a valid history does not determine current authority if the history-selection boundary is open.

https://ethereum-magicians.org/t/erc-8403-account-authority-lifecycle/29570

## ResidualAuth

ResidualAuth shows that two delegation histories can have identical current permissions and all-pairs reachability yet require opposite authorization decisions after the same direct-edge revocation.

Relation: Canon cannot discard authority history that remains future-distinguishing.

https://arxiv.org/abs/2609.08062

## NIST software and AI agent identity and authorization

NIST's 2026 project focuses on identification, authorization, auditing, and non-repudiation of autonomous software/AI agents; DevSecOps is its first implementation use case.

Relation: autonomous-agent authorization is a concrete implementation problem.

https://www.nist.gov/news-events/news/2026/02/new-concept-paper-identity-and-authority-software-agents
https://www.nist.gov/news-events/news/2026/09/comments-software-and-agentic-ai-identity-concept-paper

## CompCert

CompCert proves semantic preservation from source C to compiler-generated assembly, with observable behavior constrained by allowed source behaviors.

Relation: protected semantics can survive translation down to machine-executed code. Resolution adds an authority question CompCert does not claim to solve.

https://compcert.org/man/manual001.html

## seL4

For supported configurations, seL4 binary correctness establishes that executing binary code implements precisely the specified behavior and nothing more.

https://sel4.systems/Verification/proofs.html

## CHERI

CHERI capabilities are hardware-protected, nonforgeable tokens of authority carrying bounds and permissions, with monotonic restriction.

https://www.cl.cam.ac.uk/research/security/ctsrd/cheri/cheri-faq.html

## OpenQASM and IBM dynamic circuits

OpenQASM supports classical feed-forward based on measurement outcomes and serves as an IR between higher-level compilers and quantum hardware. IBM dynamic circuits permit mid-circuit measurement and classical logic conditioned on the result.

Relation: an outcome need not be known in advance for the relation governing its next operation to be specified and executed.

https://openqasm.com/intro.html
https://quantum.cloud.ibm.com/docs/en/guides/execute-dynamic-circuits

## C2PA

C2PA states that provenance alone cannot determine whether digital content is true, accurate, or factual.

Relation: provenance evidence does not self-authorize a stronger truth claim.

https://c2pa.org/specifications/specifications/2.2/explainer/Explainer.html

## Dynamic certification, adaptive medical software, self-driving laboratories

These fields independently expose the same structural problem: historical approval or open-ended intelligence cannot be treated as unbounded current authority.

https://cockrell.utexas.edu/news/rethinking-safety-certification-for-autonomous-systems/
https://www.fda.gov/medical-devices/software-medical-device-samd/predetermined-change-control-plans-machine-learning-enabled-medical-devices-guiding-principles
https://www.nature.com/articles/s41570-026-00847-2
