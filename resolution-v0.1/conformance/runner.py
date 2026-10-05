#!/usr/bin/env python3
# Copyright (c) 2026 Joseph Angel Lerma
# SPDX-License-Identifier: MIT
import json, sys
from pathlib import Path

def evaluate(f):
    rule, c = f["rule"], f["case"]

    if rule == "outcome_relevant_closure":
        changed_uncommitted = c["variant_a"].get("uncommitted_selector") != c["variant_b"].get("uncommitted_selector")
        changed_successor = c["variant_a"].get("authorized_successor") != c["variant_b"].get("authorized_successor")
        return "VIOLATION" if c.get("committed") is not None and changed_uncommitted and changed_successor else "CLOSED"

    if rule == "evidence_non_authority":
        return "UNRESOLVED" if c["evidence_valid"] and not c["authority_edge"] and c["claimed_result"] == "AUTHORIZED" else "CLOSED"

    if rule == "scope_binding":
        return "UNAUTHORIZED" if c["proof_valid"] and set(c["proof_scope"]) != set(c["target_scope"]) else "CLOSED"

    if rule == "exact_transition_binding":
        changed = c["authorized_transition"] != c["attempted_transition"]
        return "UNAUTHORIZED" if changed and not c.get("substitution_authorized", False) else "CLOSED"

    if rule == "composition_non_expansion":
        allowed = set(c["input_authority"]) | set(c.get("policy_grants", []))
        return "VIOLATION" if not set(c["output_authority"]).issubset(allowed) else "CLOSED"

    if rule == "effectuation_closure":
        rb, eb = c["resolved_basis"], c["effectuation_basis"]
        # The fixture declares the load-bearing basis. Compare it as a whole so
        # newly added basis components cannot silently fall outside effectuation.
        changed = rb != eb
        return "RE_RESOLVE" if changed and not c.get("atomic", False) and not c.get("re_resolved", False) else "CLOSED"

    if rule == "canon_future_sufficiency":
        return "VIOLATION" if c["canon_a"] == c["canon_b"] and c["future_result_a"] != c["future_result_b"] else "CLOSED"

    if rule == "translation_authority_preservation":
        allowed = set(c["source_authority"]) | set(c.get("explicit_expansion", []))
        return "VIOLATION" if not set(c["lower_layer_authority"]).issubset(allowed) else "CLOSED"

    if rule == "unknown_outcome_governed":
        poss = set(c["possible_outcomes"])
        mapping = c["committed_mapping"]
        obs = c["observed_outcome"]
        return "CLOSED" if poss.issubset(set(mapping)) and obs in mapping and mapping[obs] == c["executed_action"] else "UNRESOLVED"

    raise ValueError(f"unknown rule {rule}")

def main():
    p = Path(sys.argv[1] if len(sys.argv) > 1 else Path(__file__).with_name("fixtures.json"))
    data = json.loads(p.read_text())
    fixtures = data["fixtures"] if isinstance(data, dict) and "fixtures" in data else data
    failures = 0
    print(f"Resolution conformance corpus: {len(fixtures)} fixtures")
    for f in fixtures:
        got = evaluate(f)
        ok = got == f["expect"]
        print(f"{'PASS' if ok else 'FAIL'}  {f['id']}: expected={f['expect']} got={got}")
        failures += 0 if ok else 1
    print(f"\n{len(fixtures)-failures}/{len(fixtures)} fixtures matched expected Resolution state")
    return failures

if __name__ == "__main__":
    raise SystemExit(main())
